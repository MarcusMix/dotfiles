#!/usr/bin/env python3
"""Gera o estilo do Plasma "Mocha Glass" (assets/plasma-style/mocha-glass).

Painéis, popups e dicas com cantos bem arredondados, vidro fosco (desfoque atrás)
e um contorno de 1 px. As cores vêm do esquema de cores ativo (classes
ColorScheme-*), então funciona com qualquer sabor/destaque do Catppuccin.
Tudo o que não está aqui o Plasma pega do Breeze (tema "default").

Uso: python3 ferramentas/gerar_plasma_style.py
"""
import json
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent / "assets" / "plasma-style" / "mocha-glass"

ESTILO = """<style type="text/css" id="current-color-scheme">
  .ColorScheme-Background{color:#1e1e2e;}
  .ColorScheme-Text{color:#cdd6f4;}
  .ColorScheme-Highlight{color:#cba6f7;}
</style>"""


def frame(raio, margem, opac_fundo, opac_borda, prefixo="", mascara=True):
    """Elementos de uma moldura de 9 partes com cantos arredondados."""
    r = raio
    partes = []
    x0 = 0

    def grupo(id_, w, h, corpo):
        nonlocal x0
        g = (f'<g id="{prefixo}{id_}" transform="translate({x0},0)">'
             f'<rect width="{w}" height="{h}" fill="#000" fill-opacity="0"/>{corpo}</g>')
        x0 += w + 10
        return g

    def fundo(d, opac):
        return f'<path d="{d}" class="ColorScheme-Background" style="fill:currentColor;fill-opacity:{opac}"/>'

    def borda(d):
        return (f'<path d="{d}" class="ColorScheme-Text" '
                f'style="fill:none;stroke:currentColor;stroke-opacity:{opac_borda};stroke-width:1"/>')

    def cantos(opac, com_borda):
        b = (lambda d: borda(d)) if com_borda else (lambda d: "")
        h = 0.5
        return [
            ("topleft", fundo(f"M{r},0 A{r},{r} 0 0 0 0,{r} L{r},{r} Z", opac)
             + b(f"M{r},{h} A{r - h},{r - h} 0 0 0 {h},{r}")),
            ("topright", fundo(f"M0,0 A{r},{r} 0 0 1 {r},{r} L0,{r} Z", opac)
             + b(f"M0,{h} A{r - h},{r - h} 0 0 1 {r - h},{r}")),
            ("bottomleft", fundo(f"M0,0 A{r},{r} 0 0 0 {r},{r} L{r},0 Z", opac)
             + b(f"M{h},0 A{r - h},{r - h} 0 0 0 {r},{r - h}")),
            ("bottomright", fundo(f"M{r},0 A{r},{r} 0 0 1 0,{r} L0,0 Z", opac)
             + b(f"M{r - h},0 A{r - h},{r - h} 0 0 1 0,{r - h}")),
        ]

    def lados(opac, com_borda):
        b = (lambda d: borda(d)) if com_borda else (lambda d: "")
        return [
            ("top", fundo(f"M0,0 H{r} V{r} H0 Z", opac) + b(f"M0,0.5 H{r}")),
            ("bottom", fundo(f"M0,0 H{r} V{r} H0 Z", opac) + b(f"M0,{r - 0.5} H{r}")),
            ("left", fundo(f"M0,0 H{r} V{r} H0 Z", opac) + b(f"M0.5,0 V{r}")),
            ("right", fundo(f"M0,0 H{r} V{r} H0 Z", opac) + b(f"M{r - 0.5},0 V{r}")),
            ("center", fundo(f"M0,0 H{r} V{r} H0 Z", opac)),
        ]

    for id_, corpo in cantos(opac_fundo, True) + lados(opac_fundo, True):
        partes.append(grupo(id_, r, r, corpo))
    if mascara:
        salvo = prefixo
        prefixo = "mask-" + salvo
        for id_, corpo in cantos(1, False) + lados(1, False):
            partes.append(grupo(id_, r, r, corpo))
        prefixo = salvo
    for lado in ("top", "bottom", "left", "right"):
        partes.append(grupo(f"hint-{lado}-margin", margem, margem, ""))
    return partes


def svg(partes):
    largura = 4000
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{largura}" height="40">'
            f'{ESTILO}{"".join(partes)}</svg>\n')


def escrever(rel, conteudo):
    p = RAIZ / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(conteudo)


# Variante sólida (sem desfoque disponível) e translúcida (com desfoque)
for pasta, opac in (("", 0.97), ("translucent/", 0.72)):
    escrever(f"{pasta}widgets/panel-background.svg", svg(frame(14, 4, opac, 0.10)))
    escrever(f"{pasta}dialogs/background.svg", svg(frame(16, 10, opac + (0.06 if pasta else 0), 0.12)))
    escrever(f"{pasta}widgets/tooltip.svg", svg(frame(12, 8, opac + (0.10 if pasta else 0), 0.12)))

escrever("metadata.json", json.dumps({
    "KPlugin": {
        "Id": "mocha-glass",
        "Name": "Mocha Glass",
        "Description": "Vidro fosco com cantos arredondados — kde-mocha-rice",
        "Authors": [{"Name": "kde-mocha-rice"}],
        "License": "GPL-3.0",
        "Version": "1.0",
        "Website": "https://github.com/",
    },
    "X-Plasma-API-Minimum-Version": "6.0",
}, indent=2, ensure_ascii=False) + "\n")

# Desfoque mais forte e cores um pouco mais vivas atrás do vidro
escrever("plasmarc", """[ContrastEffect]
enabled=true
contrast=0.35
intensity=0.7
saturation=1.9

[AdaptiveTransparency]
enabled=true
""")
print("ok", RAIZ)
