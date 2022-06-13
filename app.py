from dash import Dash, callback, callback_context, html, dcc, Input, State, Output
from dash.exceptions import PreventUpdate
import dash_bootstrap_components as dbc
import selection
import map
from config import app


app.layout = dbc.Container([
    dbc.Row([
        dbc.Col([
            html.Img(src=app.get_asset_url(
                'logo-structure.png'), width='100%'),
            selection.component,
        ], md=3),
        dbc.Col([
            html.H1("PAEC Mercantour"),
            map.component,
        ], md=9),
    ]),
], fluid=True,
    className='dbc',
)

server = app.server


@callback(
    output={
        'selection': selection.output,
        'map': map.output,
    },
    inputs={
        'sel_input': selection.input,
        'map_input': map.input,
    }
)
def update(sel_input, map_input):
    print('selection input', sel_input)
    print('map input', map_input)
    changes = selection.process(**sel_input)
    if changes is None:
        changes = map.process(**map_input)
    if changes is None:
        changes = {'up': None, 'prairie': None}
    print('changes', changes)
    return {
        'selection': selection.update(changes),
        'map': map.update(**changes),
    }


if __name__ == "__main__":
    app.run_server(debug=True, host='0.0.0.0')
