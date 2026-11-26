import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'

const repo = 'https://github.com/kennypassenier/SOC-Survival-Guide'

const cliSidebar = {
    text: 'CLI Referentie',
    collapsed: false,
    items: [
        { text: 'Overview & equivalents', link: '/scripting/' },
        { text: 'PowerShell', link: '/scripting/powershell' },
        { text: 'BASH', link: '/scripting/bash' },
        { text: 'CMD', link: '/scripting/cmd' }
    ]
}

export default withMermaid({
    ...defineConfig({
    title: 'SOC Survival Guide',
    description: 'Naslagwerk voor de SOC-analist: CLI-referenties, netwerkmodellen, Windows, Linux en security.',
    lang: 'nl-NL',
    base: '/SOC-Survival-Guide/',

    cleanUrls: true,
    lastUpdated: true,
    sitemap: { hostname: 'https://kennypassenier.github.io/SOC-Survival-Guide/' },

    markdown: {
        lineNumbers: true,
        image: { lazyLoading: true },
        container: {
            tipLabel: 'Tip',
            warningLabel: 'Let op',
            dangerLabel: 'Gevaar',
            infoLabel: 'Info',
            detailsLabel: 'Details'
        }
    },

    themeConfig: {
        search: {
            provider: 'local',
            options: {
                translations: {
                    button: { buttonText: 'Zoeken', buttonAriaLabel: 'Zoeken' },
                    modal: {
                        noResultsText: 'Geen resultaten voor',
                        resetButtonTitle: 'Zoekopdracht wissen',
                        footer: { selectText: 'selecteren', navigateText: 'navigeren', closeText: 'sluiten' }
                    }
                }
            }
        },

        outline: { level: [2, 3], label: 'Op deze pagina' },
        docFooter: { prev: 'Vorige pagina', next: 'Volgende pagina' },
        lastUpdated: { text: 'Laatst bijgewerkt' },
        returnToTopLabel: 'Terug naar boven',
        sidebarMenuLabel: 'Menu',
        darkModeSwitchLabel: 'Thema',
        lightModeSwitchTitle: 'Naar licht thema',
        darkModeSwitchTitle: 'Naar donker thema',
        externalLinkIcon: true,

        editLink: {
            pattern: `${repo}/edit/main/docs/:path`,
            text: 'Bewerk deze pagina op GitHub'
        },
        socialLinks: [{ icon: 'github', link: repo }],
        footer: {
            message: 'Persoonlijke kennisbank, gebouwd met VitePress.',
            copyright: 'MIT-licentie'
        },

        nav: [
            { text: 'Networking', link: '/networking/', activeMatch: '/networking/' },
            { text: 'Windows', link: '/windows/', activeMatch: '/windows/' },
            { text: 'Linux', link: '/linux/', activeMatch: '/linux/' },
            { text: 'Security', link: '/security/', activeMatch: '/security/' },
            { text: 'Tools', link: '/tools/', activeMatch: '/tools/' },
            {
                text: 'CLI Referentie',
                activeMatch: '/scripting/',
                items: [
                    { text: 'Overview & equivalents', link: '/scripting/' },
                    { text: 'PowerShell', link: '/scripting/powershell' },
                    { text: 'BASH', link: '/scripting/bash' },
                    { text: 'CMD', link: '/scripting/cmd' }
                ]
            },
            {
                text: 'Progress',
                items: [
                    { text: 'Work in progress', link: '/Work_In_Progress' },
                    { text: 'Roadmap', link: '/roadmap' }
                ]
            },
            { text: 'Glossary', link: '/glossary' }
        ],

        sidebar: {
            '/networking/': [
                {
                    text: 'Reference models',
                    items: [
                        { text: 'Overview', link: '/networking/' },
                        { text: 'OSI model', link: '/networking/osi-model' },
                        { text: 'TCP/IP model', link: '/networking/tcp-ip-model' },
                        { text: 'Packet Lifecycle', link: '/networking/packet-lifecycle' },
                        { text: 'Ports & Protocols', link: '/networking/ports-and-protocols' }
                    ]
                },
                {
                    text: 'Network & infrastructure',
                    items: [
                        { text: 'IP addressing', link: '/networking/ip-addressing-basics' },
                        { text: 'Network devices', link: '/networking/network-device-basics' },
                        { text: 'VPN', link: '/networking/vpn-basics' },
                        { text: 'Troubleshooting', link: '/networking/network-troubleshooting-basics' }
                    ]
                },
                cliSidebar
            ],

            '/windows/': [
                {
                    text: 'Windows',
                    items: [
                        { text: 'Overview', link: '/windows/' },
                        { text: 'CLI Basics', link: '/windows/windows-cli-basics' },
                        { text: 'File system', link: '/windows/windows-file-system-basics' },
                        { text: 'Services', link: '/windows/windows-services' }
                    ]
                },
                {
                    text: 'Domain management',
                    items: [
                        { text: 'Active Directory', link: '/windows/active-directory-basics' },
                        { text: 'Group Policy', link: '/windows/group-policy-basics' }
                    ]
                },
                cliSidebar
            ],

            '/linux/': [
                {
                    text: 'Linux',
                    items: [
                        { text: 'Overview', link: '/linux/' },
                        { text: 'CLI Basics', link: '/linux/linux-cli-basics' },
                        { text: 'File system', link: '/linux/linux-file-system-basics' }
                    ]
                },
                cliSidebar
            ],

            '/security/': [
                {
                    text: 'Defense & continuity',
                    items: [
                        { text: 'Overview', link: '/security/' },
                        { text: 'Access Control', link: '/security/access-control-basics' },
                        { text: 'Firewalls', link: '/security/firewall-basics' },
                        { text: 'Antivirus', link: '/security/antivirus-basics' },
                        { text: 'Backup & recovery', link: '/security/data-backup-and-recovery-basics' }
                    ]
                },
                {
                    text: 'Cryptography',
                    items: [
                        { text: 'Basics', link: '/security/cryptography-basics' },
                        { text: 'Symmetric', link: '/security/symmetric-cryptography' },
                        { text: 'Asymmetric', link: '/security/asymmetric-cryptography' },
                        { text: 'Hash functions', link: '/security/cryptographic-hash-functions' }
                    ]
                },
                cliSidebar
            ],

            '/tools/': [
                {
                    text: 'Analysis & scanning',
                    items: [
                        { text: 'Overview', link: '/tools/' },
                        { text: 'Wireshark', link: '/tools/wireshark-basics' },
                        { text: 'Nmap', link: '/tools/nmap-basics' }
                    ]
                },
                cliSidebar
            ],

            '/scripting/': [
                {
                    text: 'CLI Referentie',
                    items: [
                        { text: 'Overview & equivalents', link: '/scripting/' },
                        { text: 'PowerShell', link: '/scripting/powershell' },
                        { text: 'BASH', link: '/scripting/bash' },
                        { text: 'CMD', link: '/scripting/cmd' }
                    ]
                }
            ]
        }
    }
}),
    mermaid: {
        theme: 'default',
        themeVariables: { fontSize: '18px' },
        flowchart: { useMaxWidth: false, htmlLabels: true, padding: 16, nodeSpacing: 40, rankSpacing: 50 },
        sequence: { useMaxWidth: false, actorFontSize: 18, messageFontSize: 17, noteFontSize: 16, width: 170, boxMargin: 10 }
    },
    mermaidPlugin: { class: 'mermaid' }
})
