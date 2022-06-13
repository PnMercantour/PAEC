import dash_leaflet as dl
from dash import Output, Input

from config import app, ns, PNM_bounds
from data import up_data, prairie_data


up = dl.GeoJSON(
    url=app.get_asset_url('up.json'),
    options={
        'onEachFeature': ns('UPTooltip')
    }
)

prairie = dl.GeoJSON(
    url=app.get_asset_url('prairie.json'),
    options={
        'onEachFeature': ns('prairieTooltip')
    }
)

vallees = dl.GeoJSON(
    url=app.get_asset_url('vallees.json'),
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

component = dl.Map(
    dl.LayersControl([
        dl.BaseLayer(planIGN, name='Plan IGN', checked=True),
        # dl.BaseLayer(tile.ign('ortho'), name='Orthophotos', checked=False),
        dl.Overlay(vallees, name='Vallées', checked=False),
        dl.Overlay(up, name='Unités pastorales', checked=True),
        dl.Overlay(prairie, name='Prairies', checked=True),
    ]),
    style={'width': '100%', 'height': '60vh'},
    bounds=PNM_bounds,
)

input = {
    'click': Input(component, 'click_lat_lng'),
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
    'bounds': Output(component, 'bounds'),
    'up_feature': Output(up, 'click_feature'),
    'prairie_feature': Output(prairie, 'click_feature'),
}


def update(up, prairie):
    if up is not None:
        bounds = up_data[up]['bounds']
    elif prairie is not None:
        bounds = prairie_data[prairie]['bounds']
    else:
        bounds = PNM_bounds
    return {
        'bounds': bounds,
        'up_feature': None,
        'prairie_feature': None,
    }
