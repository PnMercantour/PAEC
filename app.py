from dash import Dash, callback, callback_context, html, dcc, Input, State, Output
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import filter
import selection
import info
import map
from config import app


app.layout = dbc.Container([
    dbc.Row([
        dbc.Col([
            html.Img(src=app.get_asset_url(
                'logo-structure.png'), width='80%'),
                html.H1("PAEC Mercantour"),
                filter.component,
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
        'selection': selection.output,
        'map': map.output,
        'info': info.output,
    },
    inputs={
        'sel_input': selection.input,
        'map_input': map.input,
    }
)
def update(sel_input, map_input):
    changes = selection.process(**sel_input)
    if changes is None:
        changes = map.process(**map_input)
    if changes is None:
        changes = {'up': None, 'prairie': None}
    return {
        'selection': selection.update(changes),
        'map': map.update(**changes),
        'info': info.update(**changes)
    }


if __name__ == "__main__":
    app.run_server(debug=True, host='0.0.0.0')
