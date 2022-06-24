from dash import Dash, callback, callback_context, html, dcc, Input, State, Output
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import annuaire
import selection
import info
import map
from config import app
from data import up_id_filter_list, prairie_id_filter_list


app.layout = dbc.Container([
    dbc.Row([
        dbc.Col([
            html.Img(src=app.get_asset_url(
                'logo-structure.png'), width='80%'),
            html.H1("PAEC Mercantour"),
            annuaire.component,
            selection.component,
        ], md=3),
        dbc.Col([
            map.component,
        ], md=6),
        dbc.Col([
            info.component,
        ], md=3),
    ]),
],
    fluid=True,
    className='dbc',
)

server = app.server


@callback(
    output={
        'annuaire': annuaire.output,
        'selection': selection.output,
        'map': map.output,
        'info': info.output,
    },
    inputs={
        "annuaire_input": annuaire.input,
        'sel_input': selection.input,
        'map_input': map.input,
    }
)
def update(annuaire_input, sel_input, map_input):
    changes = annuaire.process(annuaire_input)
    update_filter = changes is not None
    if update_filter:
        up_ids = up_id_filter_list(changes)
        prairie_ids = prairie_id_filter_list(changes)
        changes['up_ids'] = up_ids
        changes['prairie_ids'] = prairie_ids
        if up_ids is None:
            # assume prairie_ids is None, too
            changes['up'] = sel_input['up']
            changes['prairie'] = sel_input['prairie']
        elif sel_input['up'] in up_ids:
            changes['up'] = sel_input['up']
            changes['prairie'] = None
        elif sel_input['prairie'] in prairie_ids:
            changes['up'] = None
            changes['prairie'] = sel_input['prairie']
        elif len(up_ids) == 1:
            changes['up'] = up_ids[0]
            changes['prairie'] = None
        elif len(prairie_ids) == 1:
            changes['up'] = None
            changes['prairie'] = prairie_ids[0]
        else:
            changes['up'] = None
            changes['prairie'] = None

    if changes is None:
        changes = selection.process(sel_input)
    if changes is None:
        changes = map.process(**map_input)
    if changes is None:
        changes = {}
    return {
        'annuaire': annuaire.update(annuaire_input, changes),
        'selection': selection.update(sel_input, changes, update_filter),
        'map': map.update(
            map_input,
            changes,
            changes.get('up_ids', up_id_filter_list(annuaire_input)),
            changes.get('prairie_ids', prairie_id_filter_list(annuaire_input))),
        'info': info.update(sel_input, changes)
    }


if __name__ == "__main__":
    app.run_server(debug=True, host='0.0.0.0')
