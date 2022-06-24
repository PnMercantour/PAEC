import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from data import gex_data, exploitant_data, prairie_data, conv_up, up_data, mesure_gestion_data, mesure_fauche_data, cat_mesure_gestion, convention_paturage_data, cat_engagement

title = html.Div()

body = dbc.CardBody()

component = dbc.Card([
    dbc.CardHeader(title),
    body,
])

output = {
    'title': Output(title, 'children'),
    'body': Output(body, 'children'),
}


def get_mesures(selection, d):
    "mesures dont au moins 1% de la surface est sur l'entité sélectionnée, nombre total de mesures intersectant l'entité"
    mesures = selection['mesures'] if selection['mesures'][0] != None else []
    return (len(mesures), [d[mesure['id']] for mesure in mesures if mesure['intersect']/d[mesure['id']]['surface'] > 0.01])


def get_conventions(up):
    "conventions de pâturage couvrant au moins 5% de la surface de l'up sélectionnée"
    conv = up['cp'] if up['cp'][0] != None else []
    return [convention_paturage_data[c['id']] for c in conv if c['intersect']/up['surface'] > 0.05]


def display_mesure_gestion(mesure):
    return html.Div([
        html.Hr(),
        html.Div(
            f"mesure de gestion #{mesure['id']} (MAEC #{mesure['maec']})"),
        html.Div(html.Strong(f"{cat_mesure_gestion[mesure['type_mesure']]}")),
        html.Div(
            f"{mesure['mesure'] if mesure['mesure'] is not None else ''} ({mesure['commentaire'] if mesure['commentaire'] is not None else ''})"),
        html.Div(f"{round(mesure['surface']/10000)} ha"),
    ])


def display_mesures_gestion(mesures):
    return html.Div([display_mesure_gestion(mesure) for mesure in mesures])


def display_exploitants(parcelles):
    return html.Div([exploitant_data[parcelle['exploitant']]['nom_complet'] for parcelle in parcelles if parcelle['exploitant'] is not None])


def display_mesure_fauche(mesure):
    return html.Div([
        html.Hr(),
        html.Div(
            f"mesure de gestion #{mesure['id']}"),
        html.Div(html.Strong(f"{cat_engagement[mesure['engagement']]}")),
        html.Div(
            f"{mesure['commentaire'] if mesure['commentaire'] is not None else ''}"),
        html.Div(f"{round(mesure['surface']/10000)} ha"),
    ])


def display_mesures_fauche(mesures):
    return html.Div([display_mesure_fauche(mesure) for mesure in mesures])


def update(input, changes):
    up_id = changes.get('up', input['up'])
    if up_id is not None:
        up = up_data[up_id]
        environ, mesures = get_mesures(up, mesure_gestion_data)
        conventions = get_conventions(up)
        return {
            'title': 'Unité pastorale',
            'body': [
                html.Div([html.Strong(up['nom']),
                         f" #{up['id']}"]),
                html.Div(f"{round(up['surface']/10000)} ha"),
                display_exploitants(conventions),
                html.Hr(),
                html.Div(
                    f"{len(mesures)} mesure(s) de gestion") if len(mesures) > 0 else "pas de mesure de gestion",
                display_mesures_gestion(mesures),
                html.Hr(),
                html.Div(f"{environ - len(mesures)} mesure(s) de gestion contigue (intersection non vide)") if environ > len(
                    mesures) else None,
            ],
        }
    prairie_id = changes.get('prairie', input['prairie'])
    if prairie_id is not None:
        prairie = prairie_data[prairie_id]
        environ, mesures = get_mesures(prairie, mesure_fauche_data)
        return {
            'title': 'Prairie',
            'body': [
                html.Div(f"{round(prairie['surface']/1000)/10} ha"),
                display_exploitants([prairie]),
                html.Hr(),
                html.Div(
                    f"{len(mesures)} mesure(s) de gestion") if len(mesures) > 0 else "pas de mesure de gestion",
                display_mesures_fauche(mesures),
                html.Hr(),
                html.Div(f"{environ - len(mesures)} mesure(s) de gestion contigue (intersection non vide)") if environ > len(
                    mesures) else None,
            ],
        }
    return {
        'title': 'pas de sélection',
        'body': None,
    }
