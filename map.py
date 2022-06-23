import dash_leaflet as dl
from dash import Output, Input
import dash_bootstrap_components as dbc


from config import app, ns, PNM_bounds
from data import up_data, prairie_data


up = dl.GeoJSON(
    url=app.get_asset_url('up.json'),
    hideout={'selected': None, 'filtered': None},
    options={
        'pane': 'my_common_pane',
        'style': ns('upStyle'),
        'filter': ns('areaFilter'),
        'onEachFeature': ns('upTooltip')
    }
)

prairie = dl.GeoJSON(
    url=app.get_asset_url('prairie.json'),
    hideout={'selected': None, 'filtered': None},
    options={
        'pane': 'my_common_pane',
        'style': ns('prairieStyle'),
        'filter': ns('areaFilter'),
        'onEachFeature': ns('prairieTooltip')
    }
)

mesure_gestion = dl.GeoJSON(
    url=app.get_asset_url('mesure_gestion.json'),
    hideout={'selected': None, 'filtered': None},
    options={
        'pane': 'my_front_pane',
        'style': ns('gestionStyle'),
        # 'filter': ns('areaFilter'),
        'onEachFeature': ns('gestionTooltip')
    }
)

mesure_fauche = dl.GeoJSON(
    url=app.get_asset_url('mesure_fauche.json'),
    hideout={'selected': None, 'filtered': None},
    options={
        'pane': 'my_front_pane',
        'style': ns('faucheStyle'),
        # 'filter': ns('areaFilter'),
        'onEachFeature': ns('faucheTooltip')
    }
)

vallee = dl.GeoJSON(
    url=app.get_asset_url('vallee.json'),
)

planIGN = dl.TileLayer(
    url="https://wxs.ign.fr/cartes/wmts?" +
    "&REQUEST=GetTile&SERVICE=WMTS&VERSION=1.0.0" +
    "&STYLE=normal" +
    "&TILEMATRIXSET=PM" +
    "&FORMAT=image/png" +
    "&LAYER=GEOGRAPHICALGRIDSYSTEMS.PLANIGNV2" +
    "&TILEMATRIX={z}" +
    "&TILEROW={y}" +
    "&TILECOL={x}",
    minZoom=0,
    maxZoom=19,
    tileSize=256,
    attribution="IGN-F/Geoportail",
)

contents = dl.LayersControl([
    dl.BaseLayer(planIGN, name='Plan IGN', checked=True),
    # dl.BaseLayer(tile.ign('ortho'), name='Orthophotos', checked=False),
    dl.Overlay(vallee, name='Vallées', checked=False),
    dl.Overlay(up, name='Unités pastorales', checked=True),
    dl.Overlay(prairie, name='Prairies', checked=True),
    dl.Overlay(mesure_gestion, name='Mesures de gestion pastorale', checked=True),
    dl.Overlay(mesure_fauche, name='Mesures prés de fauche', checked=True),
])
map = dl.Map(dl.Pane(dl.Pane(dl.Pane(
    contents,
    name='my_selection_pane',
    style={'zIndex': 600},
),
    name='my_front_pane',
    style={'zIndex': 460},
),
    name='my_common_pane',
    style={'zIndex': 450},
),
    style={'width': '100%', 'height': '80vh'},
    bounds=PNM_bounds,
)

component = dbc.Card([
    dbc.CardBody([
        map,
    ]),
])

input = {
    'click': Input(map, 'click_lat_lng'),
    'up_feature': Input(up, 'click_feature'),
    'prairie_feature': Input(prairie, 'click_feature'),
}


def process(click, up_feature, prairie_feature):
    if up_feature:
        return {
            'up': up_feature['properties']['id'],
            'prairie': None,
        }
    if prairie_feature:
        return {
            'up': None,
            'prairie':  prairie_feature['properties']['id'],
        }
    if click:
        return {
            'up': None,
            'prairie': None,
        }
    return None


output = {
    'bounds': Output(map, 'bounds'),
    'up_feature': Output(up, 'click_feature'),
    'up_hideout': Output(up, 'hideout'),
    'prairie_feature': Output(prairie, 'click_feature'),
    'prairie_hideout': Output(prairie, 'hideout'),
}


def envelope(bl):
    print(bl)
    [[a, b], [c, d]] = bl[0]
    for [[m, n], [o, p]] in bl:
        a = min(a, m)
        b = min(b, n)
        c = max(c, o)
        d = max(d, p)
    return [[a, b], [c, d]]


def update(input, changes, up_filter, prairie_filter):
    up = changes.get('up')
    prairie = changes.get('prairie')
    print('UPDATE', up, prairie, up_filter, prairie_filter)
    if up is not None:
        bounds = up_data[up]['bounds']
    elif prairie is not None:
        bounds = prairie_data[prairie]['bounds']
    elif up_filter or prairie_filter:
        # non empty filters (not None, not [])
        bounds = envelope(
            [up_data[id]['bounds'] for id in up_filter] +
            [prairie_data[id]['bounds'] for id in prairie_filter]
        )
    else:
        bounds = PNM_bounds
    return {
        'bounds': bounds,
        'up_feature': None,
        'up_hideout': {'selected': up, 'filtered': up_filter},
        'prairie_feature': None,
        'prairie_hideout': {'selected': prairie, 'filtered': prairie_filter}
    }
