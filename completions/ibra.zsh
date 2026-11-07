#compdef ibra
# ==============================================================================
# ZSH COMPLETION FOR IBRA CLI
# Author: Ibra Ramdan <ibradecode@gmail.com>
# ==============================================================================

_ibra() {
    local -a commands
    commands=(
        'run:Jalankan tugas otonom dengan agen ibra-x (Sonnet 4.6)'
        'fast:Eksekusi tugas kilat dengan model Ultra Fast 120B'
        'explore:Eksplorasi kode & audit logika mendalam (Opus Thinking)'
        'sonnet:Coding dan rekayasa arsitektur dengan Claude Sonnet 4.6'
        'init:Scaffold template proyek baru (api, worker, bot)'
        'status:Periksa metrik sistem, status Docker & router API'
        'benchmark:Uji latensi respons real-time ke router AI'
        'arsitektur:Analisis struktur modul, diagram Mermaid & refactoring'
        'keamanan:Audit celah keamanan OWASP, kebocoran secret & permissions'
        'tinjau:Audit diff Git terkini sebelum commit'
        'doctor:Diagnostik integritas konfigurasi, MCP & network'
        'clean:Bersihkan cache python & berkas temporer lingkungan'
        'notify:Kirim notifikasi alert via Telegram, Discord, atau Webhook'
        'update:Perbarui mod Ibra X 3.1 ke versi terbaru dari GitHub'
        'mcp:Tampilkan status server Model Context Protocol'
        'stats:Statistik total skills, commands, MCP, dan riwayat commit'
        'menu:Antarmuka selektor interaktif TUI'
        'version:Tampilkan informasi versi saat ini'
        'help:Tampilkan panduan bantuan CLI'
    )

    if (( CURRENT == 2 )); then
        _describe -t commands 'ibra commands' commands
    elif (( CURRENT == 3 )); then
        case "$words[2]" in
            init)
                local -a templates
                templates=('api:FastAPI REST Microservice' 'worker:Cloudflare Worker TypeScript' 'bot:Webhook Automation Bot')
                _describe -t templates 'templates' templates
                ;;
        esac
    fi
}

_ibra "$@"
