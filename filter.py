import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from data import gex_data, exploitant_data

gex_dropdown = dcc.Dropdown(options=[{'label': gex['nom_complet'], 'value': gex['id']}
                                         for gex in sorted(gex_data.values(), key=lambda item:item['nom_complet'])], placeholder="Groupe d'exploitants")

exploitant_dropdown = dcc.Dropdown(options=[{'label': exploitant['nom_complet'], 'value': exploitant['id']}
                                    for exploitant in sorted(exploitant_data.values(), key=lambda item:item['nom_complet'])], placeholder="Exploitant")


component = dbc.Card([
    dbc.CardHeader("Filtrer"),
    dbc.CardBody([
        gex_dropdown,
        exploitant_dropdown,
    ]),
])


input = {
    'gex': Input(gex_dropdown, 'value'),
    'exploitant': Input(exploitant_dropdown, 'value'),
}


def process(gex, exploitant):
    triggers = [trigger['prop_id'] for trigger in callback_context.triggered]
    if any([gex_dropdown.id in trigger for trigger in triggers]):
        if gex:
            return{
                'gex': gex,
                'exploitant': None,
            }
        else:
            return{
                'gex': None,
                'exploitant': None,
            }
    if any([exploitant_dropdown.id in trigger for trigger in triggers]):
        if exploitant:
            return{
                'gex': None,
                'exploitant': exploitant,
            }
        else:
            return{
                'gex': None,
                'prairie': None,
            }


output = {
    'gex': Output(gex_dropdown, 'value'),
    'exploitant': Output(exploitant_dropdown, 'value'),
}


def update(state):
    return {
        'gex': state['gex'],
        'exploitant': state['exploitant'],
    }
