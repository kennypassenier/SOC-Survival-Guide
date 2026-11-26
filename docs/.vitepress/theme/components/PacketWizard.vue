<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { devices, steps as allSteps } from './scenario-http'
import type { Layer } from './scenario-http'

const props = defineProps<{ from?: number; to?: number }>()

const steps = computed(() => allSteps.filter(s => s.id >= (props.from ?? 1) && s.id <= (props.to ?? 99)))
const index = ref(0)
const current = computed(() => steps.value[index.value])
const previous = computed(() => steps.value[index.value - 1])

const deviceIds = devices.map(d => d.id)
const x = (id: string) => 85 + deviceIds.indexOf(id) * 183
const nodeX = computed(() => x(current.value.at))
const linkActive = (i: number) => {
    const a = deviceIds.indexOf(previous.value?.at ?? current.value.at)
    const b = deviceIds.indexOf(current.value.at)
    return a !== b && i >= Math.min(a, b) && i < Math.max(a, b)
}

const statusLabel: Record<string, string> = {
    added: 'Toegevoegd', changed: 'Gewijzigd', removed: 'Verwijderd', kept: ''
}
const summary = computed(() => {
    const out: { status: string; names: string }[] = []
    for (const s of ['added', 'changed', 'removed'] as const) {
        const names = current.value.layers.filter(l => l.status === s).map(l => l.label)
        if (names.length) out.push({ status: s, names: names.join(', ') })
    }
    return out
})
const sortedLayers = computed<Layer[]>(() => current.value.layers)

const next = () => { if (index.value < steps.value.length - 1) index.value++ }
const prev = () => { if (index.value > 0) index.value-- }
const reset = () => { index.value = 0 }

let timer: number | undefined
const playing = ref(false)
const toggle = () => {
    if (playing.value) { clearInterval(timer); playing.value = false; return }
    if (index.value >= steps.value.length - 1) index.value = 0
    playing.value = true
    timer = window.setInterval(() => {
        if (index.value >= steps.value.length - 1) { clearInterval(timer); playing.value = false; return }
        index.value++
    }, 3500)
}
const onKey = (e: KeyboardEvent) => {
    if (e.key === 'ArrowRight') { e.preventDefault(); next() }
    if (e.key === 'ArrowLeft') { e.preventDefault(); prev() }
}
onBeforeUnmount(() => clearInterval(timer))
const root = ref<HTMLElement | null>(null)
onMounted(() => root.value?.setAttribute('tabindex', '0'))
</script>

<template>
    <div ref="root" class="pw" @keydown="onKey" aria-label="Packet wizard">
        <svg class="pw-topo" viewBox="0 0 900 150" role="img" aria-label="Netwerktopologie">
            <g v-for="i in devices.length - 1" :key="'l' + i">
                <line :x1="x(devices[i - 1].id) + 55" :y1="70" :x2="x(devices[i].id) - 55" :y2="70"
                    :class="['pw-link', { active: linkActive(i - 1) }]" />
            </g>
            <g v-for="d in devices" :key="d.id" :class="['pw-node', { current: d.id === current.at }]">
                <rect :x="x(d.id) - 55" y="38" width="110" height="64" rx="10" />
                <text :x="x(d.id)" y="66" class="pw-label">{{ d.label }}</text>
                <text :x="x(d.id)" y="86" class="pw-sub">{{ d.sub }}</text>
            </g>
            <g class="pw-packet" :style="{ transform: `translate(${nodeX}px, 0px)` }">
                <rect x="-16" y="8" width="32" height="20" rx="4" />
                <text x="0" y="22" class="pw-packet-text">{{ current.layers.length ? 'pkt' : '-' }}</text>
            </g>
        </svg>

        <div class="pw-body">
            <div class="pw-stack">
                <div class="pw-title">Pakket op dit moment</div>
                <div v-if="!sortedLayers.length" class="pw-empty">Nog geen pakket</div>
                <div v-for="l in sortedLayers" :key="l.id + l.status" :class="['pw-layer', l.status, l.id]">
                    <div class="pw-layer-head">
                        <strong>{{ l.label }}</strong>
                        <span class="pw-osi">{{ l.osi }}</span>
                        <span v-if="statusLabel[l.status]" class="pw-badge">{{ statusLabel[l.status] }}</span>
                    </div>
                    <div class="pw-fields">
                        <span v-for="f in l.fields" :key="f.k" :class="['pw-field', f.kind, { changed: f.changed }]">
                            <i class="pw-dot" />{{ f.k }}: <code>{{ f.v }}</code>
                        </span>
                    </div>
                </div>
            </div>

            <div class="pw-info">
                <div class="pw-step">Stap {{ index + 1 }} van {{ steps.length }}
                    <span v-if="current.osi" class="pw-osi">{{ current.osi }}</span>
                </div>
                <h4>{{ current.title }}</h4>
                <p>{{ current.text }}</p>
                <ul v-if="summary.length" class="pw-summary">
                    <li v-for="s in summary" :key="s.status" :class="s.status">
                        <strong>{{ statusLabel[s.status] }}:</strong> {{ s.names }}
                    </li>
                </ul>
            </div>
        </div>

        <div class="pw-controls">
            <button @click="reset" :disabled="index === 0">Reset</button>
            <button @click="prev" :disabled="index === 0">Vorige</button>
            <button @click="toggle">{{ playing ? 'Pauze' : 'Afspelen' }}</button>
            <button @click="next" :disabled="index === steps.length - 1">Volgende</button>
            <div class="pw-dots">
                <button v-for="(s, i) in steps" :key="s.id" :class="{ on: i === index }" :aria-label="'Stap ' + (i + 1)"
                    @click="index = i" />
            </div>
        </div>
        <div class="pw-legend">
            <span class="added">Toegevoegd</span><span class="changed">Gewijzigd</span><span class="removed">Verwijderd</span>
            <span class="hint">Pijltjestoetsen werken ook</span>
        </div>
        <div class="pw-always">
            <div class="pw-title">Wat verandert onderweg</div>
            <ul>
                <li><i class="pw-dot end" /><strong>Blijft gelijk van begin tot eind:</strong> de payload, Destination IP, Destination port en het protocol.</li>
                <li><i class="pw-dot hop" /><strong>Verandert bij elke hop:</strong> Source en Destination MAC, de FCS en de TTL (min 1 per router).</li>
                <li><i class="pw-dot nat" /><strong>Verandert bij NAT:</strong> Source IP en Source port. Dit gebeurt maar één keer, op de router naar het internet.</li>
            </ul>
        </div>
    </div>
</template>

<style scoped>
.pw { margin: 1.5rem 0; padding: 16px; border: 1px solid var(--vp-c-divider); border-radius: 10px; background: var(--vp-c-bg-soft); outline: none; }
.pw:focus-visible { border-color: var(--vp-c-brand-1); }
.pw-topo { width: 100%; height: auto; }
.pw-link { stroke: var(--vp-c-divider); stroke-width: 3; }
.pw-link.active { stroke: var(--vp-c-brand-1); stroke-dasharray: 8 6; animation: pw-dash 0.8s linear infinite; }
@keyframes pw-dash { to { stroke-dashoffset: -14; } }
.pw-node rect { fill: var(--vp-c-bg); stroke: var(--vp-c-divider); stroke-width: 2; }
.pw-node.current rect { stroke: var(--vp-c-brand-1); stroke-width: 3; fill: var(--vp-c-brand-soft); }
.pw-label { text-anchor: middle; font-size: 17px; font-weight: 600; fill: var(--vp-c-text-1); }
.pw-sub { text-anchor: middle; font-size: 13px; fill: var(--vp-c-text-2); }
.pw-packet { transition: transform 0.6s ease; }
.pw-packet rect { fill: var(--vp-c-brand-1); }
.pw-packet-text { text-anchor: middle; font-size: 12px; fill: #fff; font-weight: 700; }
.pw-body { display: grid; grid-template-columns: minmax(0, 1.2fr) minmax(0, 1fr); gap: 20px; margin-top: 8px; }
@media (max-width: 760px) { .pw-body { grid-template-columns: 1fr; } }
.pw-title { font-size: 13px; text-transform: uppercase; letter-spacing: .05em; color: var(--vp-c-text-2); margin-bottom: 8px; }
.pw-empty { padding: 16px; border: 1px dashed var(--vp-c-divider); border-radius: 8px; color: var(--vp-c-text-2); }
.pw-layer { padding: 8px 12px; margin-bottom: 6px; border-radius: 8px; border: 1px solid var(--vp-c-divider); background: var(--vp-c-bg); border-left-width: 6px; }
.pw-layer.added { border-left-color: var(--vp-c-green-1); }
.pw-layer.changed { border-left-color: var(--vp-c-yellow-1); }
.pw-layer.removed { border-left-color: var(--vp-c-red-1); opacity: .65; text-decoration: line-through; }
.pw-layer.kept { border-left-color: var(--vp-c-gray-2); }
.pw-layer-head { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
.pw-osi { font-size: 12px; padding: 0 6px; border-radius: 4px; background: var(--vp-c-default-soft); color: var(--vp-c-text-2); }
.pw-badge { font-size: 12px; margin-left: auto; color: var(--vp-c-text-2); }
.pw-fields { display: flex; flex-wrap: wrap; gap: 4px 14px; margin-top: 4px; font-size: 13px; color: var(--vp-c-text-2); }
.pw-field.changed { color: var(--vp-c-text-1); font-weight: 600; }
.pw-field.changed code { background: var(--vp-c-yellow-soft); }
.pw-info h4 { margin: 4px 0 8px; font-size: 18px; }
.pw-info p { margin: 0 0 10px; line-height: 1.6; }
.pw-step { font-size: 13px; color: var(--vp-c-text-2); display: flex; gap: 8px; align-items: center; }
.pw-summary { list-style: none; padding: 0; margin: 0; font-size: 14px; }
.pw-summary li { padding: 2px 0; }
.pw-summary .added strong { color: var(--vp-c-green-1); }
.pw-summary .changed strong { color: var(--vp-c-yellow-1); }
.pw-summary .removed strong { color: var(--vp-c-red-1); }
.pw-controls { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; margin-top: 14px; }
.pw-controls > button { padding: 6px 14px; border-radius: 6px; border: 1px solid var(--vp-c-divider); background: var(--vp-c-bg); color: var(--vp-c-text-1); cursor: pointer; }
.pw-controls > button:hover:not(:disabled) { border-color: var(--vp-c-brand-1); }
.pw-controls > button:disabled { opacity: .4; cursor: default; }
.pw-dots { display: flex; gap: 6px; margin-left: auto; flex-wrap: wrap; }
.pw-dots button { width: 12px; height: 12px; padding: 0; border-radius: 50%; border: 1px solid var(--vp-c-divider); background: var(--vp-c-bg); cursor: pointer; }
.pw-dots button.on { background: var(--vp-c-brand-1); border-color: var(--vp-c-brand-1); }
.pw-legend { display: flex; gap: 14px; font-size: 12px; margin-top: 10px; color: var(--vp-c-text-2); flex-wrap: wrap; }
.pw-legend .added::before, .pw-legend .changed::before, .pw-legend .removed::before { content: ''; display: inline-block; width: 10px; height: 10px; margin-right: 5px; border-radius: 2px; }
.pw-legend .added::before { background: var(--vp-c-green-1); }
.pw-legend .changed::before { background: var(--vp-c-yellow-1); }
.pw-legend .removed::before { background: var(--vp-c-red-1); }
.pw-legend .hint { margin-left: auto; }
.pw-dot { display: inline-block; width: 9px; height: 9px; margin-right: 6px; border-radius: 50%; background: var(--vp-c-gray-2); }
.pw-dot.end, .pw-field.end .pw-dot { background: var(--vp-c-brand-1); }
.pw-dot.hop, .pw-field.hop .pw-dot { background: var(--vp-c-yellow-1); }
.pw-dot.nat, .pw-field.nat .pw-dot { background: var(--vp-c-red-1); }
.pw-always { margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--vp-c-divider); font-size: 14px; }
.pw-always ul { list-style: none; padding: 0; margin: 0; }
.pw-always li { padding: 3px 0; line-height: 1.5; }
</style>
