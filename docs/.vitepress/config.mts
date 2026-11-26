import { defineConfig } from 'vitepress'

const quickCliSidebar = {
    text: 'Snelle CLI Referentie',
    collapsed: false,
    items: [
        { text: 'PowerShell.md', link: '/scripting/PowerShell' },
        { text: 'BASH.md', link: '/scripting/BASH' },
        { text: 'CMD.md', link: '/scripting/CMD' }
    ]
}

export default defineConfig({
    title: 'SOC Survival Guide',
    description: 'Persoonlijk naslagwerk voor Networking, OS, Security & Scripting',
    base: '/SOC-Survival-Guide/',

    cleanUrls: true,
    lastUpdated: true,

    themeConfig: {
        search: {
            provider: 'local'
        },

        outline: {
            level: [2, 3],
            label: 'Op deze pagina'
        },

        nav: [
            { text: 'Networking', link: '/networking/OSI', activeMatch: '/networking/' },
            { text: 'Windows', link: '/windows/Active_Directory_Basics', activeMatch: '/windows/' },
            { text: 'Linux', link: '/linux/Linux_CLI_Basics', activeMatch: '/linux/' },
            { text: 'Security', link: '/security/Cryptography_Basics', activeMatch: '/security/' },
            { text: 'Tools', link: '/tools/Wireshark_Basics', activeMatch: '/tools/' },
            {
                text: 'CLI Referentie',
                activeMatch: '/scripting/',
                items: [
                    { text: 'Overzicht', link: '/scripting/' },
                    { text: 'PowerShell', link: '/scripting/PowerShell' },
                    { text: 'BASH', link: '/scripting/BASH' },
                    { text: 'CMD', link: '/scripting/CMD' }
                ]
            },
            { text: 'WIP', link: '/Work_In_Progress' }
        ],

        sidebar: {
            '/networking/': [
                {
                    text: 'Referentiemodellen',
                    collapsed: false,
                    items: [
                        { text: 'Network Reference Models', link: '/networking/Network_Reference_Models' },
                        { text: 'OSI Model', link: '/networking/OSI' },
                        { text: 'OSI Deep Dive', link: '/networking/OSI_Deep_Dive' }
                    ]
                },
                {
                    text: 'Netwerk & Infrastructuur',
                    collapsed: false,
                    items: [
                        { text: 'IP Addressing Basics', link: '/networking/IP_Addressing_Basics' },
                        { text: 'Network Device Basics', link: '/networking/Network_Device_Basics' },
                        { text: 'VPN Basics', link: '/networking/VPN_Basics' },
                        { text: 'Network Troubleshooting', link: '/networking/Network_Troubleshooting_Basics' }
                    ]
                },
                quickCliSidebar
            ],

            '/windows/': [
                {
                    text: 'Windows & Active Directory',
                    collapsed: false,
                    items: [
                        { text: 'Windows CLI Basics', link: '/windows/Windows_CLI_Basics' },
                        { text: 'Windows File System', link: '/windows/Windows_File_System_Basics' },
                        { text: 'Windows Services', link: '/windows/Windows_Services' },
                        { text: 'Active Directory Basics', link: '/windows/Active_Directory_Basics' },
                        { text: 'Group Policy Basics', link: '/windows/Group_Policy_Basics' }
                    ]
                },
                quickCliSidebar
            ],

            '/linux/': [
                {
                    text: 'Linux Fundamenten',
                    collapsed: false,
                    items: [
                        { text: 'Linux CLI Basics', link: '/linux/Linux_CLI_Basics' },
                        { text: 'Linux File System', link: '/linux/Linux_File_System_Basics' }
                    ]
                },
                quickCliSidebar
            ],

            '/security/': [
                {
                    text: 'Cryptografie',
                    collapsed: false,
                    items: [
                        { text: 'Cryptography Basics', link: '/security/Cryptography_Basics' },
                        { text: 'Symmetric Cryptography', link: '/security/Symmetric_Cryptography' },
                        { text: 'Asymmetric Cryptography', link: '/security/Asymmetric_Cryptography' },
                        { text: 'Cryptographic Hash Functions', link: '/security/Cryptographic_Hash_Functions' }
                    ]
                },
                {
                    text: 'Verdediging & Continuïteit',
                    collapsed: false,
                    items: [
                        { text: 'Access Control Basics', link: '/security/Access_Control_Basics' },
                        { text: 'Firewall Basics', link: '/security/Firewall_Basics' },
                        { text: 'Antivirus Basics', link: '/security/Antivirus_Basics' },
                        { text: 'Data Backup & Recovery', link: '/security/Data_Backup_and_Recovery_Basics' }
                    ]
                },
                quickCliSidebar
            ],

            '/tools/': [
                {
                    text: 'Analyse & Scanning',
                    collapsed: false,
                    items: [
                        { text: 'Wireshark Basics', link: '/tools/Wireshark_Basics' },
                        { text: 'Nmap Basics', link: '/tools/Nmap_Basics' }
                    ]
                },
                quickCliSidebar
            ],

            '/scripting/': [
                {
                    text: 'CLI Naslagwerken',
                    collapsed: false,
                    items: [
                        { text: 'Overzicht', link: '/scripting/' },
                        { text: 'PowerShell', link: '/scripting/PowerShell' },
                        { text: 'BASH', link: '/scripting/BASH' },
                        { text: 'CMD', link: '/scripting/CMD' }
                    ]
                }
            ]
        }
    }
})