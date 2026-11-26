import DefaultTheme from 'vitepress/theme'
import type { Theme } from 'vitepress'
import PacketWizard from './components/PacketWizard.vue'
import './custom.css'

export default {
    extends: DefaultTheme,
    enhanceApp({ app }) {
        app.component('PacketWizard', PacketWizard)
    }
} satisfies Theme
