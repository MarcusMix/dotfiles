// Layout dos painéis do kde-mocha-rice (script do Plasma).
// Rodado pelo modulos/60-painel.sh, que define DOCK_APPS antes deste código.
//
//  ┌──────────────────────────── barra do topo (flutuante) ─────────────────────────┐
//  │  menu  áreas de trabalho  título         relógio · data          bandeja       │
//  └────────────────────────────────────────────────────────────────────────────────┘
//
//                      ┌── dock (flutuante, aparece no mouse) ───┐
//                      │    arquivos  navegador  terminal  ...    │
//                      └──────────────────────────────────────────┘

// remove os painéis atuais (o backup guarda o layout antigo)
panels().forEach(function (p) { p.remove(); });

// ---------------------------------------------------------------- barra do topo
var topo = new Panel("org.kde.panel");
topo.location = "top";
topo.height = 30;
topo.floating = true;
topo.lengthMode = "fill";
topo.hiding = "none";
topo.opacity = "translucent";

var menu = topo.addWidget("org.kde.plasma.kickoff");
menu.currentConfigGroup = ["General"];
menu.writeConfig("icon", "mocharicemenu");
menu.writeConfig("showActionButtonCaptions", false);
menu.writeConfig("compactMode", true);

var pager = topo.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("displayedText", "Number");
pager.writeConfig("showWindowIcons", false);

topo.addWidget("org.kde.plasma.panelspacer");

var relogio = topo.addWidget("org.kde.plasma.digitalclock");
relogio.currentConfigGroup = ["Appearance"];
relogio.writeConfig("showDate", true);
relogio.writeConfig("dateDisplayFormat", "BesideTime");
relogio.writeConfig("dateFormat", "custom");
relogio.writeConfig("customDateFormat", "ddd, d 'de' MMM");
relogio.writeConfig("use24hFormat", 2);
relogio.writeConfig("autoFontAndSize", false);
relogio.writeConfig("fontWeight", 600);

topo.addWidget("org.kde.plasma.panelspacer");

var bandeja = topo.addWidget("org.kde.plasma.systemtray");

// ---------------------------------------------------------------- dock
var dock = new Panel("org.kde.panel");
dock.location = "bottom";
dock.height = 54;
dock.floating = true;
dock.lengthMode = "fit";
dock.alignment = "center";
dock.hiding = "autohide";       // fica escondida; aparece ao encostar o mouse embaixo
dock.opacity = "translucent";

var tarefas = dock.addWidget("org.kde.plasma.icontasks");
tarefas.currentConfigGroup = ["General"];
tarefas.writeConfig("launchers", DOCK_APPS.split(",").map(function (a) {
  return a.indexOf("://") > 0 ? a : "applications:" + a;
}).join(","));
tarefas.writeConfig("showOnlyCurrentDesktop", false);
tarefas.writeConfig("iconSpacing", 2);
tarefas.writeConfig("indicateAudioStreams", true);
tarefas.writeConfig("maxStripes", 1);
tarefas.writeConfig("unhideOnAttention", false);  // app pedindo atenção não faz a dock reaparecer

dock.addWidget("org.kde.plasma.marginsseparator");
var lixeira = dock.addWidget("org.kde.plasma.trash");
