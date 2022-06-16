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
    gex_data = to_dict(dict(gex['properties']) for gex in json.load(f)['features'])

with (assets_path/'exploitant.json').open('r') as f:
    exploitant_data = to_dict(dict(exploitant['properties']) for exploitant in json.load(f)['features'])

with (assets_path/'convention_paturage.json').open('r') as f:
    convention_paturage_data = to_dict(dict(convention['properties']) for convention in json.load(f)['features'])

with (assets_path/'join_conv_up.json').open('r') as f:
    conv_up= json.load(f)

# for v in gex_data.values():
#     print(v)
# for v in exploitant_data.values():
#     print(v)