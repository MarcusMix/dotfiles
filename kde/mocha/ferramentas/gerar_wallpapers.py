#!/usr/bin/env python3
"""Gera os wallpapers do rice (originais, paleta Catppuccin Mocha).

Uso:  python3 ferramentas/gerar_wallpapers.py [pasta_saida] [largura] [altura]
Precisa de: numpy e pillow  (pip install numpy pillow)

Cria:
  mocha-montanhas.jpg  — montanhas em camadas com névoa, lua e estrelas
  mocha-aurora.jpg     — aurora boreal sobre um lago escuro (tela de bloqueio)
  mocha-ondas.jpg      — ondas suaves (alternativo, mais minimalista)
"""
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

P = {k: np.array([int(v[i:i + 2], 16) for i in (0, 2, 4)], dtype=np.float32) for k, v in {
    "rosewater": "f5e0dc", "flamingo": "f2cdcd", "pink": "f5c2e7", "mauve": "cba6f7",
    "red": "f38ba8", "maroon": "eba0ac", "peach": "fab387", "yellow": "f9e2af",
    "green": "a6e3a1", "teal": "94e2d5", "sky": "89dceb", "sapphire": "74c7ec",
    "blue": "89b4fa", "lavender": "b4befe", "text": "cdd6f4", "overlay0": "6c7086",
    "surface2": "585b70", "surface1": "45475a", "surface0": "313244",
    "base": "1e1e2e", "mantle": "181825", "crust": "11111b"}.items()}

SAIDA = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "assets" / "wallpapers"
W = int(sys.argv[2]) if len(sys.argv) > 2 else 3840
H = int(sys.argv[3]) if len(sys.argv) > 3 else 2160
S = W / 3840  # escala


def mix(a, b, t):
    t = np.asarray(t, dtype=np.float32)[..., None]
    return a * (1 - t) + b * t


def gradiente(paradas, n):
    """paradas = [(posição 0..1, cor)], devolve n×3."""
    pos = np.linspace(0, 1, n)
    out = np.zeros((n, 3), np.float32)
    for c in range(3):
        out[:, c] = np.interp(pos, [p for p, _ in paradas], [cor[c] for _, cor in paradas])
    return out


def ruido1d(n, rng, oitavas=6, base=4):
    """fBm 1D por interpolação cosseno de valores aleatórios."""
    x = np.linspace(0, 1, n)
    total = np.zeros(n)
    amp, freq, soma = 1.0, base, 0.0
    for _ in range(oitavas):
        pts = rng.uniform(-1, 1, freq + 2)
        xi = x * freq
        i0 = np.floor(xi).astype(int)
        f = xi - i0
        f = (1 - np.cos(f * np.pi)) / 2
        total += amp * (pts[i0] * (1 - f) + pts[i0 + 1] * f)
        soma += amp
        amp *= 0.5
        freq *= 2
    return total / soma


def estrelas(img, rng, n, y_max, brilho=1.0):
    camada = np.zeros((H, W), np.float32)
    ys = (rng.uniform(0, 1, n) ** 1.6 * y_max).astype(int)
    xs = rng.integers(0, W, n)
    br = rng.uniform(0.25, 1, n) ** 3 * brilho
    camada[ys, xs] = br * 255
    pequenas = Image.fromarray(np.clip(camada, 0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.8 * S))
    grandes = np.zeros((H, W), np.float32)
    idx = rng.choice(n, n // 40, replace=False)
    grandes[ys[idx], xs[idx]] = 255
    brilho_g = Image.fromarray(grandes.astype(np.uint8)).filter(ImageFilter.GaussianBlur(5 * S))
    e = np.asarray(pequenas, np.float32) * 2.2 + np.asarray(brilho_g, np.float32) * 6
    e = np.clip(e, 0, 255) / 255
    cor = mix(P["text"], P["lavender"], 0.4)
    return img + e[..., None] * (cor - img) * 0.9


def granulado(img, rng, forca=3.0):
    return img + rng.normal(0, forca, img.shape[:2])[..., None]


def vinheta(img, forca=0.35):
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    d = np.sqrt(((xx - W / 2) / (W / 2)) ** 2 + ((yy - H / 2) / (H / 2)) ** 2)
    v = np.clip(d - 0.55, 0, None) ** 2 * forca
    return mix(img, P["crust"], np.clip(v, 0, 1))


def salvar(img, nome):
    SAIDA.mkdir(parents=True, exist_ok=True)
    Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).save(SAIDA / nome, quality=94, subsampling=0)
    print("ok", SAIDA / nome)


# ---------------------------------------------------------------------------
def montanhas():
    rng = np.random.default_rng(7)
    yy = np.arange(H, dtype=np.float32)[:, None]
    xx = np.arange(W, dtype=np.float32)[None, :]

    # céu: crust no alto -> base -> brilho malva/rosa perto do horizonte
    ceu = gradiente([(0, P["crust"]), (0.22, P["base"]), (0.40, mix(P["base"], P["mauve"], 0.28)),
                     (0.52, mix(P["mauve"], P["pink"], 0.55) * 0.80), (0.62, P["peach"] * 0.85), (1, P["peach"])], H)
    img = np.broadcast_to(ceu[:, None, :], (H, W, 3)).copy()
    img = estrelas(img, rng, int(2600 * S * S), int(H * 0.55))

    # lua com halo
    cx, cy, r = W * 0.70, H * 0.33, 150 * S
    d = np.sqrt((xx - cx) ** 2 + (yy - cy) ** 2)
    halo = np.exp(-np.clip(d - r, 0, None) / (260 * S)) * 0.55
    img = mix(img, P["peach"], halo * 0.55)
    disco = np.clip(r - d + 1, 0, 1)
    lua = mix(P["rosewater"], P["peach"], np.clip((yy - (cy - r)) / (2 * r), 0, 1) * 0.6 + xx * 0)
    img = img * (1 - disco[..., None]) + lua * disco[..., None]

    # camadas de montanha (longe -> perto)
    camadas = [
        (0.58, 0.08, mix(P["pink"], P["mauve"], 0.6) * 0.70, 3),
        (0.64, 0.11, mix(P["mauve"], P["surface2"], 0.45) * 0.95, 4),
        (0.71, 0.13, mix(P["surface1"], P["mauve"], 0.30), 5),
        (0.78, 0.11, P["surface0"], 5),
        (0.87, 0.09, P["mantle"], 6),
        (0.95, 0.06, P["crust"], 7),
    ]
    for i, (base, amp, cor, freq) in enumerate(camadas):
        crista = H * base - ruido1d(W, rng, oitavas=7, base=freq) * H * amp - np.abs(ruido1d(W, rng, 3, 2)) * H * amp * 0.6
        cobertura = np.clip(yy - crista[None, :] + 0.5, 0, 1)
        # rosto da montanha um pouco mais claro no topo (luz da lua)
        luz = np.exp(-np.clip(yy - crista[None, :], 0, None) / (90 * S)) * 0.18
        cor_px = mix(np.broadcast_to(cor, (H, W, 3)), P["pink"], luz * (1 - i / len(camadas)))
        img = img * (1 - cobertura[..., None]) + cor_px * cobertura[..., None]
        # névoa logo acima da próxima camada
        if i < len(camadas) - 1:
            prox = H * camadas[i + 1][0]
            nevoa = np.exp(-np.abs(yy - prox + 40 * S) / (70 * S)) * 0.22 * cobertura
            img = mix(img, mix(P["mauve"], P["pink"], 0.4), nevoa)

    img = vinheta(img, 0.4)
    return granulado(img, rng, 2.4)


def aurora():
    rng = np.random.default_rng(21)
    yy = np.arange(H, dtype=np.float32)[:, None] / H
    xx = np.arange(W, dtype=np.float32)[None, :] / W
    ceu = gradiente([(0, P["crust"]), (0.45, P["mantle"]), (0.70, mix(P["base"], P["surface0"], 0.5)), (1, P["crust"])], H)
    img = np.broadcast_to(ceu[:, None, :], (H, W, 3)).copy()
    img = estrelas(img, rng, int(3000 * S * S), int(H * 0.68), 0.9)

    horizonte = 0.72
    luz = np.zeros((H, W, 3), np.float32)
    # cada fita: curva da borda de baixo, altura da cauda, cor de baixo -> cor de cima
    for y0, amp, fase, freq, cauda, c_baixo, c_cima, forca in [
            (0.50, 0.08, 0.4, 1.3, 0.085, P["teal"], P["mauve"], 1.5),
            (0.33, 0.06, 2.2, 1.7, 0.065, P["sky"], P["pink"], 0.9)]:
        borda = (y0 + amp * np.sin(xx * np.pi * 2 * freq * 0.5 + fase)
                 + 0.025 * ruido1d(W, rng, 4, 4)[None, :] + 0.12 * (xx - 0.5) ** 2)
        dy = borda - yy                        # > 0 acima da borda
        acima = np.exp(-np.clip(dy, 0, None) / cauda) * (dy > 0)
        abaixo = np.exp(-np.clip(-dy, 0, None) / 0.012) * (dy <= 0)
        perfil = acima + abaixo
        raios = 0.80 + 0.20 * ruido1d(W, rng, 2, 45)[None, :]
        varia = 0.55 + 0.45 * (0.5 + 0.5 * ruido1d(W, rng, 3, 3)[None, :])
        t = np.clip(dy / (cauda * 1.2), 0, 1) ** 0.7
        cor = mix(np.broadcast_to(c_baixo, (H, W, 3)), c_cima, t)
        luz += cor * (perfil * raios * varia * forca)[..., None]
    luz = np.asarray(Image.fromarray(np.clip(luz, 0, 255).astype(np.uint8)).filter(
        ImageFilter.GaussianBlur(4 * S)), np.float32)
    brilho = np.asarray(Image.fromarray(np.clip(luz, 0, 255).astype(np.uint8)).filter(
        ImageFilter.GaussianBlur(60 * S)), np.float32)
    img = img + luz * 0.70 + brilho * 0.35

    # lago: reflexo espelhado, desfocado e escurecido
    linha = int(H * horizonte)
    refl = img[linha - (H - linha):linha][::-1].copy()
    refl = np.asarray(Image.fromarray(np.clip(refl, 0, 255).astype(np.uint8)).filter(
        ImageFilter.GaussianBlur(5 * S)), np.float32)
    ondas_ = 0.5 + 0.5 * np.sin(np.arange(H - linha)[:, None] ** 1.15 * 0.5 / S + np.sin(xx * 30) * 2)
    img[linha:] = mix(refl * 0.55, P["crust"], 0.25 + 0.15 * ondas_)
    # silhueta de montanhas baixas na margem
    crista = horizonte - 0.015 - 0.07 * np.clip(ruido1d(W, rng, 7, 4) + 0.2, 0, 1)
    cob = np.clip((yy - crista[None, :]) * H + 0.5, 0, 1) * (yy < horizonte)
    img = mix(img, P["crust"] * 0.9, cob)
    img = vinheta(img, 0.45)
    return granulado(img, rng, 2.2)


def ondas():
    rng = np.random.default_rng(3)
    yy = np.arange(H, dtype=np.float32)[:, None] / H
    xx = np.arange(W, dtype=np.float32)[None, :] / W
    img = np.broadcast_to(gradiente([(0, P["base"]), (1, P["crust"])], H)[:, None, :], (H, W, 3)).copy()
    cores = [P["lavender"], P["blue"], P["mauve"], P["pink"], P["flamingo"]]
    for i, cor in enumerate(cores):
        y0 = 0.42 + i * 0.09
        curva = y0 + 0.07 * np.sin(xx * 3.2 + i * 0.9) + 0.03 * np.sin(xx * 7.5 - i)
        cob = np.clip((yy - curva) * H + 0.5, 0, 1)
        sombra = np.exp(-np.clip(yy - curva, 0, None) * 6)
        c = mix(np.broadcast_to(mix(cor, P["base"], 0.25 + i * 0.1), (H, W, 3)), P["crust"], 1 - sombra * 0.85)
        img = img * (1 - cob[..., None]) + c * cob[..., None]
    img = vinheta(img, 0.3)
    return granulado(img, rng, 2.0)


if __name__ == "__main__":
    salvar(montanhas(), "mocha-montanhas.jpg")
    salvar(aurora(), "mocha-aurora.jpg")
    salvar(ondas(), "mocha-ondas.jpg")
