import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from dash.exceptions import PreventUpdate
from data import gex_data, exploitant_data, exploitant_list


def exploitant_options(gex_id):
    print('gex_id', gex_id)
    exp_list = [exploitant_data[exploitant_id] for exploitant_id in gex_data[gex_id]['exploitants']] if gex_id is not None else exploitant_list
    print('exp list',exp_list[0] if len(exp_list) > 0 else None)
    return [{'label': exploitant['nom_complet'], 'value': exploitant['id']}
            for exploitant in exp_list]


gex_dropdown = dcc.Dropdown(
    options=[{'label': gex['nom_complet'], 'value': gex['id']}
             for gex in sorted(gex_data.values(), key=lambda item:item['nom_complet'])],
    placeholder="Groupe d'exploitants",
)

exploitant_dropdown = dcc.Dropdown(
    options=exploitant_options(None),
    placeholder="Exploitant",
)


component = dbc.Card([
    dbc.CardHeader("Annuaire des exploitants"),
    dbc.CardBody([
        gex_dropdown,
        exploitant_dropdown,
    ]),
])


input = {
    'gex_id': Input(gex_dropdown, 'value'),
    'exploitant_id': Input(exploitant_dropdown, 'value'),
}


def process(gex_id, exploitant_id):
    triggers = [trigger['prop_id'] for trigger in callback_context.triggered]
    if any([gex_dropdown.id in trigger for trigger in triggers]):
        options = exploitant_options(gex_id)
        return{
                'gex': gex_id,
                'exploitant': options[0]['value'] if len(options) == 1 else None,
                'exploitant_list': options,
            }
    if any([exploitant_dropdown.id in trigger for trigger in triggers]):
        if exploitant_id:
            new_gex_id = exploitant_data[exploitant_id]['gex']
            return{
                'gex': new_gex_id,
                'exploitant': exploitant_id,
                'exploitant_list': exploitant_options(new_gex_id) if gex_id is None else no_update,

            }
        else:
            return{
                'gex': gex_id,
                'exploitant': None,
                'exploitant_list': no_update,
            }
    # pas de trigger : le trigger est dans un autre module ou phase d'initialisation
    return None


output = {
    'gex': Output(gex_dropdown, 'value'),
    'exploitant': Output(exploitant_dropdown, 'value'),
    'exploitant_list': Output(exploitant_dropdown, 'options'),
}


def update(input, changes):
    return {
        'gex': changes.get('gex', no_update),
        'exploitant': changes.get('exploitant', no_update),
        'exploitant_list': changes.get('exploitant_list', no_update),
    }
