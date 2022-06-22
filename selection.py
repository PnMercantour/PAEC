import dash_bootstrap_components as dbc
from dash import Input, Output, callback, callback_context, html, no_update, dcc
from data import up_data, prairie_data, up_list, prairie_list, exploitant_data, gex_data
import annuaire

up_base_options = [{'label': f"{up['id']} - {up['nom']}", 'value': up['id']}
                   for up in up_list]


def up_id_to_options(ids):
    return [{'label': f"{id} - {up_data[id]['nom']}", 'value': id}
            for id in ids] if ids is not None else up_base_options


prairie_base_options = [{'label': f"{prairie['id']}", 'value': prairie['id']}
                        for prairie in sorted(prairie_data.values(), key=lambda item:item['id'])]


def prairie_id_to_options(ids):
    return [{'label': id, 'value': id}
            for id in ids] if ids is not None else prairie_base_options

# def up_options(context):
#     if context.get('exploitant') is not None:
#         sublist = [up_data[up_id]
#                    for up_id in exploitant_data[context['exploitant']]['ups']]
#     elif context.get('gex') is not None:
#         sublist = [up_data[up_id] for up_id in gex_data[context['gex']]['ups']]
#     else:
#         sublist = up_list
#     return [{'label': f"{up['id']} - {up['nom']}", 'value': up['id']}
#             for up in sublist]


# def prairie_options(context):
#     if context.get('exploitant') is not None:
#         sublist = [prairie_data[prairie_id]
#                    for prairie_id in exploitant_data[context['exploitant']]['prairies']]
#     elif context.get('gex') is not None:
#         sublist = [prairie_data[prairie_id]
#                    for prairie_id in gex_data[context['gex']]['prairies']]
#     else:
#         sublist = prairie_list
#     return [{'label': f"{prairie['id']}", 'value': prairie['id']}
#             for prairie in sublist]


up_dropdown = dcc.Dropdown(options=up_base_options,
                           placeholder="Unité pastorale")

prairie_dropdown = dcc.Dropdown(
    options=prairie_base_options, placeholder="Prairie")


# def get_prairie_options(changes):
#     if changes.get('exploitant') is not None:
#         return [option for option in prairie_base_options if prairie_data[option['value']]['exploitant'] == changes['exploitant']]
#     if changes.get('gex') is not None:
#         return [option for option in prairie_base_options if prairie_data[option['value']]['exploitant'] in annuaire.exploitants(changes['gex'])]
#     return prairie_base_options


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


def process(input):
    up = input['up']
    prairie = input['prairie']
    triggers = [trigger['prop_id'] for trigger in callback_context.triggered]
    if any([up_dropdown.id in trigger for trigger in triggers]):
        return {
            'up': up,
            'prairie': None,
        }
    if any([prairie_dropdown.id in trigger for trigger in triggers]):
        return{
            'up': None,
            'prairie': prairie,
        }
    return None


output = {
    'up': Output(up_dropdown, 'value'),
    'prairie': Output(prairie_dropdown, 'value'),
    'up_options': Output(up_dropdown, 'options'),
    'prairie_options': Output(prairie_dropdown, 'options'),
}


def update(input, changes, update_filter):
    print('changes', changes)
    print('filter', update_filter)
    return {
        'up':  changes.get('up', no_update),
        'prairie': changes.get('prairie', no_update),
        'up_options':  up_id_to_options(changes['up_ids']) if update_filter else no_update,
        'prairie_options': prairie_id_to_options(changes['prairie_ids']) if update_filter else no_update,
    }
