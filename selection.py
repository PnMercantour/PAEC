import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from data import up_data, prairie_data


# vallee_dropdown = dcc.Dropdown(options=[{'label': vallee['nom_vallee'], 'value': vallee['id_vallee']}
#                                for vallee in vallee_data.values()], placeholder="Choisir une vallée")

up_dropdown = dcc.Dropdown(options=[{'label': f"{up['id']} - {up['nom']}", 'value': up['id']}
                                    for up in sorted(up_data.values(), key=lambda item:item['id'])], placeholder="Unité pastorale")

prairie_dropdown = dcc.Dropdown(options=[{'label': f"{prairie['id']}", 'value': prairie['id']}
                                         for prairie in sorted(prairie_data.values(), key=lambda item:item['id'])], placeholder="Prairie")
component = dbc.Card([
    dbc.CardHeader("Rechercher"),
    dbc.CardBody([
        # vallee_dropdown,
        # html.Hr(),
        up_dropdown,
        prairie_dropdown,
    ]),
])


input = {
    'up': Input(up_dropdown, 'value'),
    'prairie': Input(prairie_dropdown, 'value'),
}


def process(up, prairie):
    triggers = [trigger['prop_id'] for trigger in callback_context.triggered]
    if any([up_dropdown.id in trigger for trigger in triggers]):
        if up:
            return{
                'up': up,
                'prairie': None,
            }
        else:
            return{
                'up': None,
                'prairie': None,
            }
    if any([prairie_dropdown.id in trigger for trigger in triggers]):
        if prairie:
            return{
                'up': None,
                'prairie': prairie,
            }
        else:
            return{
                'up': None,
                'prairie': None,
            }


output = {
    'up': Output(up_dropdown, 'value'),
    'prairie': Output(prairie_dropdown, 'value'),
}


def update(state):
    return {
        'up': state['up'],
        'prairie': state['prairie'],
    }
