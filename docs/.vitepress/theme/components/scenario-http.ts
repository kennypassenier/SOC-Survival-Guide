export type Status = 'added' | 'kept' | 'changed' | 'removed'

export type Kind = 'end' | 'hop' | 'nat'
export interface Field { k: string; v: string; changed?: boolean; kind: Kind }
export interface Layer { id: string; label: string; osi: string; status: Status; fields: Field[] }
export interface Step {
    id: number
    at: string
    title: string
    osi: string
    text: string
    layers: Layer[]
}
export interface Device { id: string; label: string; sub: string; kind: 'host' | 'switch' | 'router' | 'cloud' | 'server' }

export const devices: Device[] = [
    { id: 'laptop', label: 'Laptop', sub: '192.168.1.15', kind: 'host' },
    { id: 'switch', label: 'Switch', sub: 'Layer 2', kind: 'switch' },
    { id: 'router', label: 'Router', sub: 'NAT, 192.168.1.1', kind: 'router' },
    { id: 'isp', label: 'ISP router', sub: 'hop', kind: 'cloud' },
    { id: 'server', label: 'Webserver', sub: '93.184.216.34', kind: 'server' }
]

const http = (s: Status): Layer => ({
    id: 'http', label: 'HTTP-request', osi: 'L7', status: s,
    fields: [{ k: 'Method', v: 'GET /index.html', kind: 'end' }, { k: 'Host', v: 'www.voorbeeld.be', kind: 'end' }]
})
const tcp = (s: Status, srcPort = '51432', changed = false): Layer => ({
    id: 'tcp', label: 'TCP-header', osi: 'L4', status: s,
    fields: [
        { k: 'Source port', v: srcPort, changed, kind: 'nat' },
        { k: 'Destination port', v: '80', kind: 'end' },
        { k: 'Flags', v: 'PSH, ACK', kind: 'end' }
    ]
})
const ip = (s: Status, ttl = '64', src = '192.168.1.15', changed: string[] = []): Layer => ({
    id: 'ip', label: 'IP-header', osi: 'L3', status: s,
    fields: [
        { k: 'Source IP', v: src, changed: changed.includes('src'), kind: 'nat' },
        { k: 'Destination IP', v: '93.184.216.34', kind: 'end' },
        { k: 'TTL', v: ttl, changed: changed.includes('ttl'), kind: 'hop' },
        { k: 'Protocol', v: '6 (TCP)', kind: 'end' }
    ]
})
const eth = (s: Status, dst: string, src: string, changed = false): Layer => ({
    id: 'eth', label: 'Ethernet-header', osi: 'L2', status: s,
    fields: [
        { k: 'Destination MAC', v: dst, changed, kind: 'hop' },
        { k: 'Source MAC', v: src, changed, kind: 'hop' },
        { k: 'EtherType', v: '0x0800 (IPv4)', kind: 'end' }
    ]
})
const fcs = (s: Status): Layer => ({
    id: 'fcs', label: 'Ethernet-trailer (FCS)', osi: 'L2', status: s,
    fields: [{ k: 'Checksum', v: 'CRC-32 over het hele frame', kind: 'hop' }]
})

export const steps: Step[] = [
    {
        id: 1, at: 'laptop', title: 'Voorbereiding afgerond', osi: '',
        text: 'De browser kent het IP-adres van www.voorbeeld.be via DNS (93.184.216.34). Omdat dit adres buiten het eigen subnet ligt, heeft ARP het MAC-adres van de default gateway opgeleverd (CC:CC:CC:33:33:33). Er is nog geen pakket.',
        layers: []
    },
    {
        id: 2, at: 'laptop', title: 'Applicatie maakt de request', osi: 'L7',
        text: 'De browser bouwt het HTTP-verzoek. Dit is de payload: de data die alle onderliggende lagen zullen omhullen.',
        layers: [http('added')]
    },
    {
        id: 3, at: 'laptop', title: 'Transport voegt de TCP-header toe', osi: 'L4',
        text: 'TCP voegt een header toe met bronpoort (een tijdelijke poort) en doelpoort 80. De data is nu een segment. De 3-way handshake is al afgerond, daarom staan de vlaggen op PSH en ACK.',
        layers: [tcp('added'), http('kept')]
    },
    {
        id: 4, at: 'laptop', title: 'Network voegt de IP-header toe', osi: 'L3',
        text: 'IP voegt bron- en doeladres toe en zet de TTL op 64. De data is nu een pakket. Het doel-IP is extern, dus het pakket moet naar de default gateway.',
        layers: [ip('added'), tcp('kept'), http('kept')]
    },
    {
        id: 5, at: 'laptop', title: 'Data Link voegt het Ethernet-frame toe', osi: 'L2',
        text: 'Het doel-MAC is dat van de router, niet van de webserver: een MAC-adres geldt alleen binnen het lokale netwerk. Daarnaast komt er een trailer met een controlesom (FCS). De data is nu een frame.',
        layers: [eth('added', 'CC:CC:CC:33:33:33', 'AA:AA:AA:11:11:11'), ip('kept'), tcp('kept'), http('kept'), fcs('added')]
    },
    {
        id: 6, at: 'laptop', title: 'Physical zet het frame om in signalen', osi: 'L1',
        text: 'De netwerkkaart zet de bits om in elektrische signalen of radiogolven. Aan de inhoud van het frame verandert niets.',
        layers: [eth('kept', 'CC:CC:CC:33:33:33', 'AA:AA:AA:11:11:11'), ip('kept'), tcp('kept'), http('kept'), fcs('kept')]
    },
    {
        id: 7, at: 'switch', title: 'Switch forwardt op MAC-adres', osi: 'L2',
        text: 'De switch leest alleen het doel-MAC, zoekt de poort in de MAC address table en stuurt het frame door. Het frame blijft volledig ongewijzigd en de IP-header wordt niet bekeken.',
        layers: [eth('kept', 'CC:CC:CC:33:33:33', 'AA:AA:AA:11:11:11'), ip('kept'), tcp('kept'), http('kept'), fcs('kept')]
    },
    {
        id: 8, at: 'router', title: 'Router verwijdert de Ethernet-header', osi: 'L2',
        text: 'Het doel-MAC is van de router zelf, dus hij accepteert het frame. De decapsulation haalt de Ethernet-header en de trailer eraf. Wat overblijft is het IP-pakket.',
        layers: [eth('removed', 'CC:CC:CC:33:33:33', 'AA:AA:AA:11:11:11'), ip('kept'), tcp('kept'), http('kept'), fcs('removed')]
    },
    {
        id: 9, at: 'router', title: 'Router routeert en doet NAT', osi: 'L3, L4',
        text: 'De router verlaagt de TTL met 1 en berekent de checksum opnieuw. Met NAT vervangt hij het private bron-IP door zijn publieke adres en past de bronpoort aan. De koppeling bewaart hij in de NAT-tabel, zodat het antwoord terugkomt.',
        layers: [ip('changed', '63', '203.0.113.5', ['ttl', 'src']), tcp('changed', '40001', true), http('kept')]
    },
    {
        id: 10, at: 'router', title: 'Router bouwt een nieuw frame', osi: 'L2',
        text: 'Voor de volgende hop maakt de router een nieuwe Ethernet-header met zijn eigen WAN-MAC als bron en het MAC van de ISP-router als doel. De IP-adressen blijven ongewijzigd.',
        layers: [eth('added', 'EE:EE:EE:55:55:55', 'CC:CC:CC:44:44:44'), ip('kept', '63', '203.0.113.5'), tcp('kept', '40001'), http('kept'), fcs('added')]
    },
    {
        id: 11, at: 'isp', title: 'ISP-router: volgende hop', osi: 'L2, L3',
        text: 'Elke router onderweg doet hetzelfde: de L2-header vervangen en de TTL met 1 verlagen. Het bron- en doel-IP veranderen niet. Als de TTL op 0 komt, wordt het pakket weggegooid en volgt een ICMP-melding.',
        layers: [eth('changed', 'DD:DD:DD:66:66:66', 'EE:EE:EE:77:77:77', true), ip('changed', '62', '203.0.113.5', ['ttl']), tcp('kept', '40001'), http('kept'), fcs('changed')]
    },
    {
        id: 12, at: 'server', title: 'Server verwijdert de Ethernet-header', osi: 'L2',
        text: 'De netwerkkaart controleert het doel-MAC en de FCS. Klopt alles, dan verwijdert hij de Ethernet-header en de trailer.',
        layers: [eth('removed', 'DD:DD:DD:66:66:66', 'EE:EE:EE:77:77:77'), ip('kept', '62', '203.0.113.5'), tcp('kept', '40001'), http('kept'), fcs('removed')]
    },
    {
        id: 13, at: 'server', title: 'Server verwijdert de IP-header', osi: 'L3',
        text: 'De IP-stack ziet dat het doeladres 93.184.216.34 van deze server is en haalt de IP-header eraf. Het protocol 6 geeft aan dat het segment naar TCP gaat.',
        layers: [ip('removed', '62', '203.0.113.5'), tcp('kept', '40001'), http('kept')]
    },
    {
        id: 14, at: 'server', title: 'Server verwijdert de TCP-header', osi: 'L4',
        text: 'TCP ziet doelpoort 80 en levert de data af aan de webserversoftware die op die poort luistert. Daarbij blijft de verbinding bijgehouden, zodat het antwoord via dezelfde weg terugkeert.',
        layers: [tcp('removed', '40001'), http('kept')]
    },
    {
        id: 15, at: 'server', title: 'Webserver verwerkt de request', osi: 'L7',
        text: 'De webserver leest GET /index.html en bereidt de HTML-respons voor. Die terugweg verloopt in omgekeerde volgorde, waarbij de router via de NAT-tabel het antwoord bij de juiste laptop aflevert.',
        layers: [http('kept')]
    }
]
