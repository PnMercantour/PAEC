import json

from config import assets_path


def to_dict(l, key='id'):
    "builds a dict from an iterable <l>, indexing on <key>"
    return {i[key]: i for i in l}


def to_bounds(b):
    "converts a standard bbox into leaflet bounds object"
    return [[b[1], b[0]], [b[3], b[2]]]


with (assets_path/'up.json').open('r') as f:
    up_data = to_dict(dict(up['properties'], bounds=to_bounds(
        up['bbox'])) for up in json.load(f)['features'])

with (assets_path/'prairie.json').open('r') as f:
    prairie_data = to_dict(dict(prairie['properties'], bounds=to_bounds(
        prairie['bbox'])) for prairie in json.load(f)['features'])


with (assets_path/'gex.json').open('r') as f:
    gex_data = to_dict(dict(gex['properties'])
                       for gex in json.load(f)['features'])
# Ajout d'un pseudo groupe pour les exploitants indépendants
gex_data[0] = {"id": 0, "nom_complet": " -- Exploitants indépendants --",
               "type": None, "nom": None, "adresse": None}

with (assets_path/'exploitant.json').open('r') as f:
    exploitant_data = to_dict(
        dict(exploitant['properties']) for exploitant in json.load(f)['features'])
# Assignation du pseudo groupe aux exploitants indépendants
for exploitant in exploitant_data.values():
    if exploitant['gex'] is None:
        exploitant['gex'] = 0

with (assets_path/'mesure_gestion.json').open('r') as f:
    mesure_gestion_data = to_dict(
        dict(mesure_gestion['properties']) for mesure_gestion in json.load(f)['features']
    )

with (assets_path/'cat_mesure_gestion.json').open('r') as f:
    cat_mesure_gestion = {i['id']: i['label'] for i in json.load(f)}

with (assets_path/'mesure_fauche.json').open('r') as f:
    mesure_fauche_data = to_dict(
        dict(mesure_fauche['properties']) for mesure_fauche in json.load(f)['features']
    )

with (assets_path/'convention_paturage.json').open('r') as f:
    convention_paturage_data = to_dict(
        dict(convention['properties']) for convention in json.load(f)['features'])

with (assets_path/'join_conv_up.json').open('r') as f:
    conv_up = json.load(f)


def up_par_exploitant(exploitant):
    conventions = [convention for convention in convention_paturage_data.values(
    ) if convention['exploitant'] == exploitant]
    return [m['id_up'] for m in conv_up if m['id_cp'] in [convention['id'] for convention in conventions]]


# listes triées par ordre de présentation
up_list = sorted(up_data.values(), key=lambda item: item['id'])
prairie_list = sorted(prairie_data.values(), key=lambda item: item['id'])

gex_list = sorted(gex_data.values(), key=lambda item: item['nom_complet'])

exploitant_list = sorted(exploitant_data.values(),
                         key=lambda item: item['nom_complet'])

for id, gex in gex_data.items():
    gex['exploitants'] = [exploitant['id']
                          for exploitant in exploitant_list if exploitant['gex'] == id]

# mise en cache des jointures

for id, exploitant in exploitant_data.items():
    # TODO trier les listes unitaires?
    exploitant['conventions'] = list(set([convention['id']
                                          for convention in convention_paturage_data.values() if convention['exploitant'] == id]))
    exploitant['ups'] = list(set([m['id_up']
                                  for m in conv_up if m['id_cp'] in exploitant['conventions']]))
    exploitant['prairies'] = list(set([prairie['id']
                                       for prairie in prairie_data.values() if prairie['exploitant'] == id]))


def gex_cache(gex):
    "met en cache les listes triées de conventions, up et prairies"
    exploitants = gex['exploitants']
    conv_set = set()
    up_set = set()
    prairie_set = set()
    for exploitant_id in exploitants:
        exploitant = exploitant_data[exploitant_id]
        for convention_id in exploitant['conventions']:
            conv_set.add(convention_id)
        for up_id in exploitant['ups']:
            up_set.add(up_id)
        for prairie_id in exploitant['prairies']:
            prairie_set.add(prairie_id)
    gex['conventions'] = list(conv_set)
    gex['ups'] = [up['id'] for up in up_list if up['id'] in up_set]
    gex['prairies'] = [prairie['id']
                       for prairie in prairie_list if prairie['id'] in prairie_set]


for gex in gex_data.values():
    gex_cache(gex)


def up_id_filter_list(context):
    if context.get('exploitant') is not None:
        return exploitant_data[context['exploitant']]['ups']
    elif context.get('gex') is not None:
        return gex_data[context['gex']]['ups']
    else:
        return None


def prairie_id_filter_list(context):
    if context.get('exploitant') is not None:
        return exploitant_data[context['exploitant']]['prairies']
    elif context.get('gex') is not None:
        return gex_data[context['gex']]['prairies']
    else:
        return None
