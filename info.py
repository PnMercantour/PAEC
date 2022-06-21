import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from data import gex_data, exploitant_data, prairie_data, conv_up

info_exploitant = html.Div('Pas de données')
info_conventions = html.Div()

component = dbc.Card([
    dbc.CardHeader('Conventions de pâturage'),
    dbc.CardBody(info_conventions),
    dbc.CardHeader("Pas de sélection"),
    dbc.CardBody([
        info_exploitant
    ]),
])

output = {'info': Output(info_exploitant, 'children'),
          'info_conventions': Output(info_conventions, 'children'), }


def update(changes):
    up = changes.get ('up', None)
    prairie = changes.get('prairie', None)
    exploitant = None
    if prairie:
        exploitant = prairie_data[prairie]['exploitant']
    if up:
        conventions = sorted([conv for conv in conv_up if conv['id_up'] == up], key=lambda item: item['intersection'], reverse=True)
        print('conventions', conventions)
        return {
            'info': 'Pas de données',
            'info_conventions': str(conventions),
            }
    if exploitant:
        return {
            'info': str(exploitant_data[exploitant]),
            'info_conventions': None,
        }
    else:
        return {
            'info': None,
            'info_conventions': None,
            }
