import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from dash.exceptions import PreventUpdate
from data import gex_data, gex_list, exploitant_data, exploitant_list


def exploitant_id_to_options(ids):
    "<ids>: liste d'identifiants d'exploitant ou None (pas de filtre)"
    exploitants = [exploitant_data[id]
                   for id in ids] if ids is not None else exploitant_list
    return [{'label': exploitant['nom_complet'], 'value': exploitant['id']}
            for exploitant in exploitants]


def exploitant_options(gex_id):
    "gex_id ou None (pas de filtre)"
    return exploitant_id_to_options(gex_data[gex_id]['exploitants']if gex_id is not None else None)


gex_dropdown = dcc.Dropdown(
    options=[{'label': gex['nom_complet'], 'value': gex['id']}
             for gex in gex_list],
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
    'gex': Input(gex_dropdown, 'value'),
    'exploitant': Input(exploitant_dropdown, 'value'),
}


def process(input):
    gex_id = input['gex']
    exploitant_id = input['exploitant']
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
