"""Génère les illustrations SVG de la Session 19 (style des figures du cours)."""
import math
import random
from pathlib import Path

OUT = Path('/Users/rich/Projects/CollegeBdB/physics_203-J28-BB/session2026/cours/images')

BLUE, DBLUE = '#2b6cb0', '#1a4a80'
RED, GREEN, ORANGE = '#c53030', '#2f855a', '#dd6b20'
GREY, TXT, SUB = '#7a8a9a', '#333', '#555'

DEFS = ''.join(
    f'<marker id="arr{n}" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" '
    f'markerHeight="7" orient="auto"><path d="M 0 0 L 10 5 L 0 10 z" fill="{c}"/></marker>'
    for n, c in (('B', BLUE), ('R', RED), ('G', GREEN), ('O', ORANGE), ('K', GREY))
)


def svg(name, w, h, title, body):
    doc = (f'<?xml version="1.0" encoding="UTF-8"?>\n'
           f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" '
           f'xmlns="http://www.w3.org/2000/svg" font-family="sans-serif">\n'
           f'<defs>{DEFS}</defs>\n'
           f'<rect width="{w}" height="{h}" fill="white"/>\n'
           f'<text x="{w / 2}" y="28" text-anchor="middle" font-size="16" '
           f'font-weight="bold" fill="{TXT}">{title}</text>\n{body}</svg>\n')
    (OUT / name).write_text(doc, encoding='utf-8')
    print('écrit', name)


def t(x, y, s, size=12, fill=TXT, anchor='middle', weight='normal', style='normal'):
    return (f'<text x="{x:.1f}" y="{y:.1f}" text-anchor="{anchor}" font-size="{size}" '
            f'fill="{fill}" font-weight="{weight}" font-style="{style}">{s}</text>\n')


def sub(base, s, sup=False):
    """Sub/superscript via tspan : les caractères Unicode ₀₁ₜᵏ ne sont pas
    dans la police par défaut de rsvg-convert (ils sortent en carrés)."""
    return (f'{base}<tspan font-size="9" dy="{"-4" if sup else "3"}">{s}</tspan>')


def box(x, y, w, h, fill, stroke, rx=10, dash=''):
    d = f' stroke-dasharray="{dash}"' if dash else ''
    return (f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" '
            f'stroke="{stroke}" stroke-width="1.6"{d}/>\n')


# ---------------------------------------------------------------- 1. boucle RL
def rl_loop():
    b = ''
    b += box(40, 110, 250, 150, '#ebf4ff', BLUE)
    b += t(165, 142, 'AGENT', 14, BLUE, weight='bold')
    b += t(165, 176, 'Politique π', 16, TXT, weight='bold')
    b += t(165, 204, 'réseau, règles ou table Q', 11, SUB)
    b += t(165, 240, 'décide', 12, SUB, style='italic')

    b += box(530, 110, 250, 150, '#f0fff4', GREEN)
    b += t(655, 142, 'ENVIRONNEMENT', 14, GREEN, weight='bold')
    b += t(655, 176, 'Moteur physique', 16, TXT, weight='bold')
    b += t(655, 204, 'forces → intégration → contacts', 11, SUB)
    b += t(655, 240, 'calcule les conséquences', 12, SUB, style='italic')

    b += (f'<path d="M 290 140 C 380 60, 440 60, 526 140" fill="none" stroke="{BLUE}" '
          f'stroke-width="3" marker-end="url(#arrB)"/>\n')
    b += t(410, 70, sub('action a', 't'), 14, BLUE, weight='bold')
    b += t(410, 88, 'couple, braquage, force', 11, SUB)

    b += (f'<path d="M 530 228 C 440 300, 380 300, 294 228" fill="none" stroke="{GREEN}" '
          f'stroke-width="3" marker-end="url(#arrG)"/>\n')
    b += t(410, 302, sub('observation o', 't+1') + ' (capteurs)', 13, GREEN, weight='bold')

    b += (f'<path d="M 530 250 C 440 352, 380 352, 294 250" fill="none" stroke="{ORANGE}" '
          f'stroke-width="3" marker-end="url(#arrO)"/>\n')
    b += t(410, 350, sub('récompense r', 't') + ' (note scalaire)', 13, ORANGE, weight='bold')
    b += t(410, 372, "L'agent ne voit jamais l'état complet : seulement ce que les capteurs mesurent.",
           11, SUB, style='italic')
    svg('rl_loop.svg', 820, 390, 'La boucle du Reinforcement Learning', b)


# ------------------------------------------------------- 2. couloir Q-learning
def q_corridor():
    b = ''
    xs = [60, 250, 440, 630]
    q = [0.087, 0.215, 0.500, None]
    for i, x in enumerate(xs):
        goal = i == 3
        b += box(x, 70, 130, 70, '#f0fff4' if goal else '#ebf4ff', GREEN if goal else BLUE)
        b += t(x + 65, 102, f'S{i}', 16, GREEN if goal else BLUE, weight='bold')
        b += t(x + 65, 124, 'ARRIVÉE' if goal else 'état', 11, SUB)
    for i in range(3):
        x0, x1 = xs[i] + 130, xs[i + 1]
        b += (f'<line x1="{x0 + 4}" y1="105" x2="{x1 - 6}" y2="105" stroke="{BLUE}" '
              f'stroke-width="2.5" marker-end="url(#arrB)"/>\n')
        b += t((x0 + x1) / 2, 94, 'R', 12, BLUE, weight='bold')
        r = '+1' if i == 2 else '−0.02'
        b += t((x0 + x1) / 2, 128, f'r = {r}', 11, ORANGE if i == 2 else SUB)

    base, scale = 330, 220
    b += f'<line x1="40" y1="{base}" x2="780" y2="{base}" stroke="{GREY}" stroke-width="1.2"/>\n'
    b += t(410, 186, 'Q(s, R) après propagation', 13, TXT, weight='bold')
    for x, v in zip(xs, q):
        cx = x + 65
        if v is None:
            b += t(cx, base - 12, 'terminal', 12, GREEN, style='italic')
            continue
        hgt = v * scale
        b += (f'<rect x="{cx - 30}" y="{base - hgt:.1f}" width="60" height="{hgt:.1f}" '
              f'fill="{BLUE}" fill-opacity="0.75" stroke="{DBLUE}"/>\n')
        b += t(cx, base - hgt - 8, f'{v:.3f}', 13, DBLUE, weight='bold')
    b += (f'<path d="M 490 352 C 440 372, 360 372, 320 352" fill="none" stroke="{RED}" '
          f'stroke-width="2" stroke-dasharray="6 4" marker-end="url(#arrR)"/>\n')
    b += (f'<path d="M 300 352 C 250 372, 170 372, 130 352" fill="none" stroke="{RED}" '
          f'stroke-width="2" stroke-dasharray="6 4" marker-end="url(#arrR)"/>\n')
    b += t(610, 370, "la valeur remonte depuis l'arrivée", 12, RED, weight='bold')
    b += t(410, 395, 'α = 0.5 · γ = 0.9 · politique gloutonne obtenue : toujours R', 11, SUB)
    svg('q_learning_corridor.svg', 820, 410, 'Q-learning sur un couloir de 4 cases', b)


# ------------------------------------------------------- 3. facteur gamma
def gamma_plot():
    x0, y0, x1, y1 = 90, 320, 760, 70
    kmax = 30
    X = lambda k: x0 + (x1 - x0) * k / kmax
    Y = lambda v: y0 - (y0 - y1) * v
    b = ''
    for v in (0, 0.25, 0.5, 0.75, 1.0):
        b += (f'<line x1="{x0}" y1="{Y(v):.1f}" x2="{x1}" y2="{Y(v):.1f}" '
              f'stroke="#e2e8f0" stroke-width="1"/>\n')
        b += t(x0 - 10, Y(v) + 4, f'{v:g}', 11, SUB, anchor='end')
    for k in range(0, kmax + 1, 5):
        b += t(X(k), y0 + 20, str(k), 11, SUB)
    b += f'<line x1="{x0}" y1="{y0}" x2="{x1 + 10}" y2="{y0}" stroke="{TXT}" stroke-width="1.4"/>\n'
    b += f'<line x1="{x0}" y1="{y0}" x2="{x0}" y2="{y1 - 10}" stroke="{TXT}" stroke-width="1.4"/>\n'
    b += t((x0 + x1) / 2, y0 + 42, 'nombre de pas dans le futur k', 12, TXT)
    b += (f'<text x="30" y="{(y0 + y1) / 2}" text-anchor="middle" font-size="12" fill="{TXT}" '
          f'transform="rotate(-90 30 {(y0 + y1) / 2})">{sub("poids γ", "k", sup=True)}</text>\n')
    for g, c, lab in ((0.99, RED, 'γ = 0.99'), (0.9, BLUE, 'γ = 0.9'), (0.5, GREEN, 'γ = 0.5')):
        pts = ' '.join(f'{X(k):.1f},{Y(g ** k):.1f}' for k in range(kmax + 1))
        b += f'<polyline points="{pts}" fill="none" stroke="{c}" stroke-width="3"/>\n'
        yl = Y(g ** kmax)
        b += t(x1 + 8, yl + 4 if g != 0.5 else yl - 6, lab, 12, c, anchor='start', weight='bold')
    k = 10
    b += (f'<line x1="{X(k)}" y1="{y0}" x2="{X(k)}" y2="{y1}" stroke="{GREY}" '
          f'stroke-width="1.2" stroke-dasharray="5 4"/>\n')
    for g, c in ((0.99, RED), (0.9, BLUE)):
        v = g ** k
        b += f'<circle cx="{X(k)}" cy="{Y(v):.1f}" r="5" fill="{c}"/>\n'
        b += t(X(k) + 10, Y(v) - 6, sub(f'{g}', '10', sup=True) + f' ≈ {v:.2f}',
               12, c, anchor='start', weight='bold')
    svg('rl_discount_gamma.svg', 860, 380, 'Le facteur γ : combien vaut une récompense future ?', b)


# ------------------------------------------------------- 4. cycle neuroevolution
def neuro_cycle():
    b = ''
    boxes = {
        'top': (300, 45, '1. Population', 'N génomes (poids du réseau)', BLUE, '#ebf4ff'),
        'right': (570, 190, '2. Évaluer', 'même épisode pour tous', GREEN, '#f0fff4'),
        'bottom': (300, 340, '3. Sélectionner', 'élites + tournoi', ORANGE, '#fffaf0'),
        'left': (30, 190, '4. Muter / croiser', sub('w', 'i') + "′ = " + sub('w', 'i') + ' + ε', RED, '#fff5f5'),
    }
    for key, (x, y, head, caption, c, f) in boxes.items():
        b += box(x, y, 220, 100, f, c)
        b += t(x + 110, y + 26, head, 14, c, weight='bold')
        b += t(x + 110, y + 45, caption, 11, SUB)
    random.seed(4)
    cols = ['#63b3ed', '#4299e1', '#90cdf4', '#3182ce', '#bee3f8', '#2c5282', '#4a90d9', '#7fb3e6']
    for i in range(8):
        b += (f'<circle cx="{328 + i * 23}" cy="118" r="8" fill="{cols[i]}" '
              f'stroke="{DBLUE}" stroke-width="1"/>\n')
    fit = [0.35, 0.8, 0.55, 0.95, 0.2, 0.65, 0.45, 0.72]
    for i, v in enumerate(fit):
        h = v * 34
        b += (f'<rect x="{592 + i * 22}" y="{278 - h:.1f}" width="14" height="{h:.1f}" '
              f'fill="{GREEN}" fill-opacity="0.8"/>\n')
    order = sorted(range(8), key=lambda i: -fit[i])
    for rank, i in enumerate(order):
        elite = rank < 2
        b += (f'<circle cx="{328 + rank * 23}" cy="418" r="8" '
              f'fill="{"#f6ad55" if elite else "#e2e8f0"}" '
              f'stroke="{ORANGE if elite else GREY}" stroke-width="{2 if elite else 1}"/>\n')
    b += t(410, 438, 'élites conservées (orange)', 10, ORANGE)
    b += t(140, 262, 'petit bruit sur chaque gène', 11, SUB)
    b += t(140, 280, '(probabilité p)', 11, SUB)
    arrows = ('M 522 95 Q 680 95 680 186', 'M 680 292 Q 680 390 524 390',
              'M 298 390 Q 140 390 140 294', 'M 140 188 Q 140 95 296 95')
    for d in arrows:
        b += f'<path d="{d}" fill="none" stroke="{GREY}" stroke-width="2.5" marker-end="url(#arrK)"/>\n'
    b += t(410, 232, 'une génération', 15, TXT, weight='bold')
    b += t(410, 254, 'répéter jusqu\'au budget', 12, SUB, style='italic')
    svg('neuroevolution_cycle.svg', 820, 460, 'Neuroevolution : le cycle d\'une génération', b)


# ------------------------------------------------------- 5. réseau 7-8-2
def network():
    inp = ['rayon −60°', 'rayon −30°', 'rayon 0°', 'rayon +30°', 'rayon +60°',
           'vitesse', 'erreur de cap']
    xi, xh, xo = 190, 430, 670
    yi = [90 + 48 * i for i in range(7)]
    yh = [78 + 42.5 * i for i in range(8)]
    yo = [200, 300]
    b = ''
    for a in yi:
        for c in yh:
            b += f'<line x1="{xi}" y1="{a}" x2="{xh}" y2="{c:.1f}" stroke="{GREY}" stroke-opacity="0.3" stroke-width="0.8"/>\n'
    for a in yh:
        for c in yo:
            b += f'<line x1="{xh}" y1="{a:.1f}" x2="{xo}" y2="{c}" stroke="{GREY}" stroke-opacity="0.45" stroke-width="0.9"/>\n'
    for i, (y, lab) in enumerate(zip(yi, inp)):
        c = BLUE if i < 5 else GREEN
        b += f'<circle cx="{xi}" cy="{y}" r="13" fill="{c}" stroke="white" stroke-width="2"/>\n'
        b += t(xi - 22, y + 4, lab, 12, c, anchor='end', weight='bold')
    for y in yh:
        b += f'<circle cx="{xh}" cy="{y:.1f}" r="12" fill="#a0aec0" stroke="{GREY}" stroke-width="1.5"/>\n'
    for y, (l1, l2) in zip(yo, (('accélération', 'a ∈ [0, 1]'), ('braquage', 's ∈ [−1, 1]'))):
        b += f'<circle cx="{xo}" cy="{y}" r="15" fill="{RED}" stroke="white" stroke-width="2"/>\n'
        b += t(xo + 26, y - 2, l1, 13, RED, anchor='start', weight='bold')
        b += t(xo + 26, y + 15, l2, 11, SUB, anchor='start')
    b += t(xi, 440, '7 entrées', 12, TXT, weight='bold')
    b += t(xi, 456, '(normalisées)', 11, SUB)
    b += t(xh, 440, '8 neurones cachés', 12, TXT, weight='bold')
    b += t(xh, 456, '(tanh)', 11, SUB)
    b += t(xo, 440, '2 sorties', 12, TXT, weight='bold')
    b += t(xo, 456, '(commandes)', 11, SUB)
    b += t(410, 486, '(7 × 8 + 8) + (8 × 2 + 2) = 82 paramètres = le génome', 13, DBLUE, weight='bold')
    svg('network_7_8_2.svg', 820, 500, 'Réseau de commande 7 → 8 → 2', b)


# ------------------------------------------------------- 6. voiture + raycasts
def car_rays():
    left = [(250, 460), (250, 250), (330, 120), (560, 70), (840, 70)]
    right = [(430, 460), (430, 300), (480, 225), (610, 195), (840, 195)]
    segs = [(left[i], left[i + 1]) for i in range(len(left) - 1)]
    segs += [(right[i], right[i + 1]) for i in range(len(right) - 1)]
    car = (340, 370)
    dmax = 260

    def hit(p, d):
        best = None
        for (ax, ay), (bx, by) in segs:
            ex, ey = bx - ax, by - ay
            den = d[0] * ey - d[1] * ex
            if abs(den) < 1e-9:
                continue
            tt = ((ax - p[0]) * ey - (ay - p[1]) * ex) / den
            u = ((ax - p[0]) * d[1] - (ay - p[1]) * d[0]) / den
            if tt > 0 and 0 <= u <= 1 and (best is None or tt < best):
                best = tt
        return best

    b = ''
    road = ' '.join(f'{x},{y}' for x, y in left + right[::-1])
    b += f'<polygon points="{road}" fill="#edf2f7"/>\n'
    for wall in (left, right):
        pts = ' '.join(f'{x},{y}' for x, y in wall)
        b += f'<polyline points="{pts}" fill="none" stroke="{TXT}" stroke-width="4"/>\n'
    b += (f'<line x1="560" y1="70" x2="610" y2="195" stroke="{GREEN}" stroke-width="3" '
          f'stroke-dasharray="7 5"/>\n')
    b += t(600, 62, 'checkpoint', 12, GREEN, weight='bold')

    for ang in (-60, -30, 0, 30, 60):
        a = math.radians(ang)
        d = (math.sin(a), -math.cos(a))
        dist = hit(car, d)
        # un tir qui touche presque à la portée max compte comme « rien »
        if dist is not None and dist < dmax - 6:
            ex, ey = car[0] + d[0] * dist, car[1] + d[1] * dist
            b += f'<line x1="{car[0]}" y1="{car[1]}" x2="{ex:.1f}" y2="{ey:.1f}" stroke="{BLUE}" stroke-width="2"/>\n'
            b += f'<circle cx="{ex:.1f}" cy="{ey:.1f}" r="5" fill="{RED}"/>\n'
            x = 1 - dist / dmax
            # étiquette posée à 62 % du rayon : les cinq ne se chevauchent plus
            lx, ly = car[0] + d[0] * dist * 0.62, car[1] + d[1] * dist * 0.62
            b += t(lx, ly - 7, f'x = {x:.2f}', 11, RED, weight='bold')
        else:
            ex, ey = car[0] + d[0] * dmax, car[1] + d[1] * dmax
            b += (f'<line x1="{car[0]}" y1="{car[1]}" x2="{ex:.1f}" y2="{ey:.1f}" stroke="{GREY}" '
                  f'stroke-width="2" stroke-dasharray="5 4"/>\n')
            lx, ly = car[0] + d[0] * dmax * 0.72, car[1] + d[1] * dmax * 0.72
            b += t(lx, ly - 7, 'x = 0', 11, GREY, weight='bold')

    tgt = (585, 132)
    b += (f'<line x1="{car[0]}" y1="{car[1]}" x2="{tgt[0]}" y2="{tgt[1]}" stroke="{GREEN}" '
          f'stroke-width="2" stroke-dasharray="3 3" marker-end="url(#arrG)"/>\n')
    head_ang = math.atan2(tgt[0] - car[0], car[1] - tgt[1])
    r = 70
    ax1, ay1 = car[0], car[1] - r
    ax2, ay2 = car[0] + r * math.sin(head_ang), car[1] - r * math.cos(head_ang)
    b += (f'<path d="M {ax1} {ay1} A {r} {r} 0 0 1 {ax2:.1f} {ay2:.1f}" fill="none" '
          f'stroke="{ORANGE}" stroke-width="2.5"/>\n')
    # pas d'étiquette sur l'arc : la légende l'explique, et elle chevauchait
    # les étiquettes des rayons.
    b += (f'<g transform="translate({car[0]} {car[1]})">'
          f'<rect x="-14" y="-24" width="28" height="48" rx="5" fill="{BLUE}" stroke="{DBLUE}" stroke-width="2"/>'
          f'<path d="M -8 -12 L 0 -22 L 8 -12 z" fill="white"/></g>\n')

    b += box(556, 286, 258, 152, '#fffaf0', ORANGE)
    b += t(685, 312, 'Normalisation', 13, ORANGE, weight='bold')
    b += t(685, 336, sub('x = 1 − d / d', 'max'), 13, TXT, weight='bold')
    b += t(685, 360, '1 = obstacle collé', 11, SUB)
    b += t(685, 378, '0 = rien à portée', 11, SUB)
    b += t(685, 400, '— — rayon sans contact', 11, GREY)
    b += t(685, 420, 'arc orange = erreur de cap', 11, ORANGE)
    svg('car_raycast_sensors.svg', 840, 460, 'Capteurs : 5 raycasts et erreur de cap', b)


# ------------------------------------------------------- 7. pipeline compute GPU
def gpu_pipeline():
    b = ''
    b += box(210, 58, 590, 344, '#f7fafc', GREY, rx=14, dash='8 5')
    b += t(505, 80, 'VRAM — les particules ne quittent jamais la carte', 12, GREY, weight='bold')

    b += box(24, 170, 160, 110, '#fffaf0', ORANGE)
    b += t(104, 198, 'CPU', 15, ORANGE, weight='bold')
    b += t(104, 222, 'dt, gravité, émission', 11, SUB)
    b += t(104, 242, 'quelques octets', 11, SUB)
    b += t(104, 258, 'par frame', 11, SUB)
    b += (f'<line x1="186" y1="225" x2="236" y2="175" stroke="{ORANGE}" stroke-width="2.5" '
          f'marker-end="url(#arrO)"/>\n')
    b += t(196, 178, 'dispatch', 11, ORANGE, anchor='end', weight='bold')

    b += box(240, 98, 290, 170, '#ebf4ff', BLUE)
    b += t(385, 122, 'Compute shader', 14, BLUE, weight='bold')
    b += t(385, 140, 'groupes de travail (ici 8 threads par groupe)', 10, SUB)
    for g in range(4):
        y = 154 + g * 26
        b += t(258, y + 14, f'G{g}', 10, SUB, anchor='start')
        for k in range(8):
            idle = g == 3 and k >= 5
            b += (f'<rect x="{285 + k * 28}" y="{y}" width="22" height="18" rx="3" '
                  f'fill="{"#e2e8f0" if idle else BLUE}" '
                  f'fill-opacity="{1 if idle else 0.8}" stroke="{GREY if idle else DBLUE}"/>\n')
    b += t(487, 266, 'i ≥ N → return', 10, RED, weight='bold')

    b += box(580, 100, 200, 56, '#f0fff4', GREEN)
    b += t(680, 124, 'Buffer A', 13, GREEN, weight='bold')
    b += t(680, 142, 'état au pas n (lecture)', 10, SUB)
    b += box(580, 210, 200, 56, '#fff5f5', RED)
    b += t(680, 234, 'Buffer B', 13, RED, weight='bold')
    b += t(680, 252, 'état au pas n+1 (écriture)', 10, SUB)
    b += (f'<line x1="578" y1="130" x2="534" y2="150" stroke="{GREEN}" stroke-width="2.5" '
          f'marker-end="url(#arrG)"/>\n')
    b += (f'<line x1="532" y1="220" x2="576" y2="236" stroke="{RED}" stroke-width="2.5" '
          f'marker-end="url(#arrR)"/>\n')
    b += (f'<path d="M 782 150 C 810 170, 810 196, 782 216" fill="none" stroke="{GREY}" '
          f'stroke-width="2" marker-end="url(#arrK)"/>\n')
    b += (f'<path d="M 770 210 C 748 190, 748 176, 770 158" fill="none" stroke="{GREY}" '
          f'stroke-width="2" marker-end="url(#arrK)"/>\n')
    b += t(690, 188, 'ping-pong', 11, GREY, anchor='end', weight='bold')

    b += box(240, 310, 540, 74, '#faf5ff', '#6b46c1')
    b += t(510, 336, 'Rendu : vertex + fragment shader', 14, '#6b46c1', weight='bold')
    b += t(510, 358, 'lisent le buffer à jour et dessinent les particules → écran', 11, SUB)
    b += (f'<line x1="680" y1="268" x2="680" y2="306" stroke="#6b46c1" stroke-width="2.5" '
          f'marker-end="url(#arrB)"/>\n')
    svg('gpu_compute_pipeline.svg', 820, 420, 'Particules sur GPU : le pipeline compute', b)


# ------------------------------------------------------- 8. grille spatiale
def spatial_grid():
    random.seed(11)
    n = 40
    pts = [(random.uniform(0.04, 0.96), random.uniform(0.04, 0.96)) for _ in range(n)]
    focus = min(range(n), key=lambda i: (pts[i][0] - 0.52) ** 2 + (pts[i][1] - 0.48) ** 2)
    cells = 6
    size = 330
    panels = ((40, 'Toutes les paires : O(N²)'), (450, 'Grille spatiale : voisins seulement'))
    b = ''
    fx, fy = pts[focus]
    cxf, cyf = int(fx * cells), int(fy * cells)
    neigh = [i for i, (x, y) in enumerate(pts)
             if i != focus and abs(int(x * cells) - cxf) <= 1 and abs(int(y * cells) - cyf) <= 1]
    for px, title in panels:
        py = 70
        b += t(px + size / 2, 58, title, 13, TXT, weight='bold')
        b += f'<rect x="{px}" y="{py}" width="{size}" height="{size}" fill="#f7fafc" stroke="{GREY}"/>\n'
        grid = px == 450
        if grid:
            c = size / cells
            b += (f'<rect x="{px + (cxf - 1) * c:.1f}" y="{py + (cyf - 1) * c:.1f}" '
                  f'width="{3 * c:.1f}" height="{3 * c:.1f}" fill="{ORANGE}" fill-opacity="0.18"/>\n')
            for k in range(1, cells):
                b += f'<line x1="{px + k * c:.1f}" y1="{py}" x2="{px + k * c:.1f}" y2="{py + size}" stroke="{GREY}" stroke-opacity="0.6"/>\n'
                b += f'<line x1="{px}" y1="{py + k * c:.1f}" x2="{px + size}" y2="{py + k * c:.1f}" stroke="{GREY}" stroke-opacity="0.6"/>\n'
        targets = neigh if grid else [i for i in range(n) if i != focus]
        for i in targets:
            x, y = pts[i]
            b += (f'<line x1="{px + fx * size:.1f}" y1="{py + fy * size:.1f}" x2="{px + x * size:.1f}" '
                  f'y2="{py + y * size:.1f}" stroke="{RED}" stroke-opacity="0.45" stroke-width="1"/>\n')
        for i, (x, y) in enumerate(pts):
            f = i == focus
            b += (f'<circle cx="{px + x * size:.1f}" cy="{py + y * size:.1f}" r="{7 if f else 4.5}" '
                  f'fill="{RED if f else BLUE}" stroke="white" stroke-width="1"/>\n')
    b += t(40 + size / 2, 425, f'{n - 1} comparaisons pour cette particule', 12, RED, weight='bold')
    b += t(40 + size / 2, 443, f'{n * (n - 1) // 2} paires au total', 11, SUB)
    b += t(450 + size / 2, 425, f'{len(neigh)} comparaisons (9 cellules voisines)', 12, RED, weight='bold')
    b += t(450 + size / 2, 443, 'coût ≈ O(N) en pratique', 11, SUB)
    svg('spatial_grid.svg', 820, 460, 'Particules en interaction : pourquoi une grille', b)
    print(f'  -> particule focus : {len(neigh)} voisins en grille, {n - 1} sans grille')


# ------------------------------------------------------- 9. pipeline modele du monde
def world_model_loop():
    b = ''
    steps = [
        (20, 'Moteur physique', 'Rapier — vérité terrain', BLUE, '#ebf4ff'),
        (225, 'Jeu de données', '(s, a, s′) enregistrés', GREEN, '#f0fff4'),
        (430, 'Entraînement', 'apprendre f(s,a) ≈ s′', ORANGE, '#fffaf0'),
        (635, 'Modèle appris', 'un réseau, pas un solveur', RED, '#fff5f5'),
    ]
    for x, head, caption, c, f in steps:
        b += box(x, 96, 175, 96, f, c)
        b += t(x + 87, 124, head, 13, c, weight='bold')
        b += t(x + 87, 146, caption, 10, SUB)
        b += t(x + 87, 172, '', 10, SUB)
    for x in (195, 400, 605):
        b += (f'<line x1="{x}" y1="144" x2="{x + 28}" y2="144" stroke="{GREY}" '
              f'stroke-width="2.5" marker-end="url(#arrK)"/>\n')
    b += t(87, 224, 'coûteux : contacts, itérations', 10, SUB)
    b += t(628, 224, 'rapide : quelques multiplications', 10, SUB)

    b += (f'<path d="M 722 196 C 722 268, 480 268, 480 300" fill="none" stroke="{RED}" '
          f'stroke-width="2.5" marker-end="url(#arrR)"/>\n')
    b += (f'<path d="M 480 300 C 480 330, 700 330, 700 300" fill="none" stroke="{RED}" '
          f'stroke-width="2.5" marker-end="url(#arrR)"/>\n')
    b += box(430, 292, 270, 56, '#fff5f5', RED)
    b += t(565, 316, 'Rollout : le modèle se nourrit', 11, RED, weight='bold')
    b += t(565, 334, 'de ses propres prédictions', 11, RED)
    b += (f'<path d="M 700 300 C 700 246, 722 240, 722 200" fill="none" stroke="{RED}" '
          f'stroke-width="2" stroke-dasharray="6 4" marker-end="url(#arrR)"/>\n')
    b += t(565, 372, "C'est ici que l'erreur s'accumule — pas à l'entraînement.", 11, SUB, style='italic')
    b += t(565, 390, 'Un modèle excellent sur un pas peut diverger sur mille.', 11, SUB, style='italic')
    svg('world_model_pipeline.svg', 830, 410,
        'Modèle du monde : remplacer le solveur par un réseau', b)


# ------------------------------------------------------- 10. derive du modele
def world_model_drift():
    b = ''
    x0, y0, w, h = 70, 70, 330, 240
    b += t(x0 + w / 2, 58, '1. Roulage : la trajectoire dérive', 13, TXT, weight='bold')
    b += f'<rect x="{x0}" y="{y0}" width="{w}" height="{h}" fill="#f7fafc" stroke="{GREY}"/>\n'
    truth, model = [], []
    for i in range(61):
        u = i / 60
        tx = x0 + 24 + u * (w - 48)
        ty = y0 + h - 40 - (180 * u - 130 * u * u) * (h - 70) / 60
        truth.append((tx, ty))
        d = (u ** 2) * 46
        model.append((tx, ty - d))
    b += ('<polyline points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in truth) +
          f'" fill="none" stroke="{BLUE}" stroke-width="3"/>\n')
    b += ('<polyline points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in model) +
          f'" fill="none" stroke="{RED}" stroke-width="3" stroke-dasharray="7 4"/>\n')
    for k in (20, 40, 60):
        b += (f'<line x1="{truth[k][0]:.1f}" y1="{truth[k][1]:.1f}" x2="{model[k][0]:.1f}" '
              f'y2="{model[k][1]:.1f}" stroke="{ORANGE}" stroke-width="1.6" stroke-dasharray="3 3"/>\n')
    b += t(x0 + 40, y0 + 30, 'vérité (solveur)', 11, BLUE, anchor='start', weight='bold')
    b += t(x0 + 40, y0 + 48, 'modèle appris', 11, RED, anchor='start', weight='bold')
    b += t(x0 + w / 2, y0 + h + 20, 'même départ, même commandes', 10, SUB)

    px0, py0, pw, ph = 470, 70, 330, 240
    b += t(px0 + pw / 2, 58, "2. Erreur cumulée sur 300 pas", 13, TXT, weight='bold')
    b += f'<rect x="{px0}" y="{py0}" width="{pw}" height="{ph}" fill="#f7fafc" stroke="{GREY}"/>\n'
    n = 300
    X = lambda k: px0 + 44 + (k / n) * (pw - 62)
    logmax, logmin = math.log10(30), math.log10(1e-3)
    Y = lambda e: py0 + ph - 34 - (math.log10(e) - logmin) / (logmax - logmin) * (ph - 56)
    for dec in (-3, -2, -1, 0, 1):
        e = 10.0 ** dec
        b += (f'<line x1="{px0 + 44}" y1="{Y(e):.1f}" x2="{px0 + pw - 18}" y2="{Y(e):.1f}" '
              f'stroke="#e2e8f0" stroke-width="1"/>\n')
        b += t(px0 + 38, Y(e) + 4, f'1e{dec:+d}', 9, SUB, anchor='end')
    lin = [(X(k), Y(1e-3 * k)) for k in range(1, n + 1)]
    comp = [(X(k), Y(min(1.01 ** k, 30))) for k in range(1, n + 1)]
    b += ('<polyline points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in lin) +
          f'" fill="none" stroke="{GREEN}" stroke-width="3"/>\n')
    b += ('<polyline points="' + ' '.join(f'{x:.1f},{y:.1f}' for x, y in comp) +
          f'" fill="none" stroke="{RED}" stroke-width="3"/>\n')
    b += t(X(40), Y(0.10), 'linéaire : ε·k', 11, GREEN, anchor='start', weight='bold')
    b += t(X(30), Y(2.9), 'multiplicatif : 1.01ᵏ', 11, RED, anchor='start', weight='bold')
    b += t(px0 + pw / 2, py0 + ph + 20, 'erreur par pas de 1e−3 — échelle log', 10, SUB)
    b += t(415, 380, 'Une erreur de 1e−3 par pas devient 0.3 en 300 pas (linéaire),', 11, SUB, style='italic')
    b += t(415, 398, 'ou ×20 (multiplicatif). Aucune des deux n\'est acceptable pour un long roulage.',
           11, SUB, style='italic')
    svg('world_model_drift.svg', 830, 415, "Le problème central : l'erreur s'accumule", b)


for fn in (rl_loop, q_corridor, gamma_plot, neuro_cycle, network, car_rays, gpu_pipeline,
           spatial_grid, world_model_loop, world_model_drift):
    fn()
