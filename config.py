from dotenv import load_dotenv
from pathlib import Path
from dash import Dash
from dash_extensions.javascript import Namespace
import dash_bootstrap_components as dbc

ns = Namespace('PNM', 'PAEC')

app_dir = Path(__file__).parent
load_dotenv(app_dir/'.env')

assets_path = app_dir / 'assets'

app = Dash(__name__, title='PAEC Mercantour', external_stylesheets=[
           dbc.themes.SLATE, dbc.icons.FONT_AWESOME])

PNM_bounds = [[43.8, 6.5], [44.5, 7.7]]
