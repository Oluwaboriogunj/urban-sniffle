"""
╔══════════════════════════════════════════════════════════════════════╗
║    NIGERIA vs USA — Investment Dashboard                             ║
║    Flask Backend  ·  app.py                                         ║
║                                                                      ║
║  SETUP:                                                              ║
║    pip install flask flask-cors                                      ║
║                                                                      ║
║  RUN:                                                                ║
║    python app.py                                                     ║
║    Then open http://127.0.0.1:5000                                   ║
╚══════════════════════════════════════════════════════════════════════╝
"""

from flask import Flask, jsonify, render_template, send_from_directory
from flask_cors import CORS
import json, os

app = Flask(__name__, template_folder="templates", static_folder="static")
CORS(app)

# ─────────────────────────────────────────────
# REAL MARKET DATA  (March 2026)
# ─────────────────────────────────────────────
MARKET_DATA = {
    "years": [2020, 2021, 2022, 2023, 2024, 2025],
    "ngx_returns":    [50.0,  6.1, -17.0, 45.3, 35.0, 51.19],
    "sp500_returns":  [18.4, 28.7, -18.1, 26.3, 25.0, 17.9],
    "inflation_ng":   [13.2, 15.6,  18.6, 24.5, 32.7, 33.0],
    "inflation_us":   [ 1.2,  7.0,   6.5,  3.4,  2.9,  2.5],
    "fx_impact":      [  0,    0,     0,  -35,  -50,  -25],
}

STATS = {
    "ngx_return_2025":  "+51.19%",
    "ngx_ytd_2026":     "+27.5%",
    "ngx_market_cap":   "₦127.4T",
    "ngx_tbill":        "~20%",
    "ngx_inflation":    "~33%",
    "sp_return_2025":   "+17.9%",
    "sp_peak_2025":     "6,932",
    "sp_market_cap":    "$61.1T",
    "us_tbill":         "~4.3%",
    "us_inflation":     "~2.5%",
}

NGX_SECTORS = {
    "Banking & Finance": 42,
    "Telecom": 18,
    "Consumer Goods": 15,
    "Oil & Gas": 12,
    "Industrial": 8,
    "Others": 5,
}

SP_SECTORS = {
    "Technology": 31,
    "Healthcare": 13,
    "Financials": 13,
    "Consumer Disc.": 11,
    "Industrials": 9,
    "Others": 23,
}

NGX_TOP_STOCKS = [
    {"name": "GTCO",            "return2025": 68.4, "div_yield": 12.1, "mkt_cap_bn": 1420},
    {"name": "Zenith Bank",     "return2025": 54.2, "div_yield": 10.8, "mkt_cap_bn": 1150},
    {"name": "MTN Nigeria",     "return2025": 39.7, "div_yield":  7.2, "mkt_cap_bn": 2340},
    {"name": "Dangote Cement",  "return2025": 44.1, "div_yield":  6.5, "mkt_cap_bn": 5800},
    {"name": "Access Holdings", "return2025": 61.3, "div_yield":  9.4, "mkt_cap_bn":  890},
]

SP_TOP_STOCKS = [
    {"name": "NVDA", "return2025": 171.0, "div_yield": 0.03, "mkt_cap_bn": 2900},
    {"name": "MSFT", "return2025":  12.3, "div_yield":  0.7, "mkt_cap_bn": 3100},
    {"name": "AAPL", "return2025":  30.1, "div_yield":  0.5, "mkt_cap_bn": 3700},
    {"name": "AMZN", "return2025":  44.7, "div_yield":  0.0, "mkt_cap_bn": 2100},
    {"name": "META", "return2025":  65.2, "div_yield":  0.3, "mkt_cap_bn": 1600},
]

COMPARE_DATA = [
    {"factor": "2025 Nominal Return",            "ngx": "+51.19%",   "sp": "+17.9%",    "ngx_win": True},
    {"factor": "2025 Real Return (after infl.)", "ngx": "~+18%",     "sp": "~+15%",     "ngx_win": True},
    {"factor": "2025 USD-Adjusted Return",       "ngx": "Negative",  "sp": "+17.9%",    "ngx_win": False},
    {"factor": "3-Year Growth ($100 base)",      "ngx": "~$55 USD",  "sp": "~$180 USD", "ngx_win": False},
    {"factor": "Market Cap (USD)",               "ngx": "~$70B",     "sp": "~$61.1T",   "ngx_win": False},
    {"factor": "Listed Companies",               "ngx": "~200",      "sp": "500–5,000+","ngx_win": False},
    {"factor": "Capital Gains Tax",              "ngx": "0%",        "sp": "15–20%",    "ngx_win": True},
    {"factor": "T-Bill Yield",                   "ngx": "~20%",      "sp": "~4.3%",     "ngx_win": True},
    {"factor": "Inflation Rate (2026)",          "ngx": "~33%",      "sp": "~2.5%",     "ngx_win": False},
    {"factor": "Dividend Yield",                 "ngx": "8–12%",     "sp": "1.5–2%",    "ngx_win": True},
    {"factor": "Currency Risk",                  "ngx": "Very High", "sp": "Low",       "ngx_win": False},
    {"factor": "Liquidity",                      "ngx": "Moderate",  "sp": "Very High", "ngx_win": False},
]

ROADMAP = [
    {
        "step": 1, "color": "#3b9eff",
        "title": "Clarify your currency base",
        "desc": "Naira earner → NGX is your home advantage. Dollar earner → naira's ~75% devaluation (2023–26) completely erodes NGX nominal gains. This single decision shapes your entire strategy."
    },
    {
        "step": 2, "color": "#ffaa00",
        "title": "Set your risk profile",
        "desc": "Conservative → S&P 500 index funds (VOO, SPY). Aggressive → NGX blue chips or split. Moderate → 60% US / 40% NGX. Never invest beyond your tolerance."
    },
    {
        "step": 3, "color": "#00d97e",
        "title": "Build a 3–6 month emergency fund",
        "desc": "Nigeria: money market funds yield 22–26%. USA: high-yield savings or T-bills at ~4.3%. Invest only genuine surplus capital — never money you may urgently need."
    },
    {
        "step": 4, "color": "#3b9eff",
        "title": "Choose your allocation split",
        "desc": "Naira investor: 70% NGX + 30% USD assets (Eurobonds, dollar ETFs). Diaspora/USD: 70% S&P 500 + 20% NGX blue chips + 10% bonds. Global: 60/20/20."
    },
    {
        "step": 5, "color": "#b482ff",
        "title": "Open the right accounts",
        "desc": "For NGX: licensed broker + CSCS number. Platforms: Chaka, Bamboo, Trove, Risevest. For US from Nigeria: Bamboo, Trove, Risevest. Diaspora: Fidelity, Vanguard, Schwab."
    },
    {
        "step": 6, "color": "#ffaa00",
        "title": "Pick your investment style",
        "desc": "Passive (beginner): VOO/SPY for US; NGX sector funds. Active (experienced): GTCO, Zenith, MTN Nigeria, Dangote for NGX; NVDA, MSFT, QQQ for US markets."
    },
    {
        "step": 7, "color": "#00d97e",
        "title": "Review, rebalance, compound",
        "desc": "Review every 6 months. Reinvest dividends. Increase contributions as income grows. A 10-year horizon smooths most volatility in both markets."
    },
]

# ─────────────────────────────────────────────
# SIMULATOR HELPER
# ─────────────────────────────────────────────
def simulate_portfolio(ngx_pct: float, initial: float) -> dict:
    """Compute blended portfolio growth over 2019–2025."""
    sp_pct = 100 - ngx_pct
    ngx_r  = MARKET_DATA["ngx_returns"]
    sp_r   = MARKET_DATA["sp500_returns"]

    blend  = [initial]
    sp100  = [initial]
    ngx100 = [initial]

    for i in range(len(ngx_r)):
        r = ngx_r[i] * ngx_pct / 100 + sp_r[i] * sp_pct / 100
        blend.append(round(blend[-1]  * (1 + r / 100), 2))
        sp100.append(round(sp100[-1]  * (1 + sp_r[i] / 100), 2))
        ngx100.append(round(ngx100[-1] * (1 + ngx_r[i] / 100), 2))

    final   = blend[-1]
    gain    = round(final - initial, 2)
    pct_gain= round((final / initial - 1) * 100, 2)

    return {
        "labels": [2019] + MARKET_DATA["years"],
        "blend":  blend,
        "sp100":  sp100,
        "ngx100": ngx100,
        "summary": {
            "initial":    initial,
            "final":      final,
            "gain":       gain,
            "pct_gain":   pct_gain,
            "final_sp":   sp100[-1],
            "final_ngx":  ngx100[-1],
            "vs_sp":      round(final - sp100[-1], 2),
            "vs_ngx":     round(final - ngx100[-1], 2),
        }
    }

# ─────────────────────────────────────────────
# ROUTES
# ─────────────────────────────────────────────

@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/market-data")
def api_market_data():
    return jsonify(MARKET_DATA)


@app.route("/api/stats")
def api_stats():
    return jsonify(STATS)


@app.route("/api/sectors")
def api_sectors():
    return jsonify({"ngx": NGX_SECTORS, "sp500": SP_SECTORS})


@app.route("/api/top-stocks")
def api_top_stocks():
    return jsonify({"ngx": NGX_TOP_STOCKS, "sp500": SP_TOP_STOCKS})


@app.route("/api/compare")
def api_compare():
    return jsonify(COMPARE_DATA)


@app.route("/api/roadmap")
def api_roadmap():
    return jsonify(ROADMAP)


@app.route("/api/simulate")
def api_simulate():
    from flask import request
    try:
        ngx_pct = float(request.args.get("ngx_pct", 40))
        initial = float(request.args.get("initial",  10000))
        if not (0 <= ngx_pct <= 100):
            return jsonify({"error": "ngx_pct must be 0–100"}), 400
        if initial <= 0:
            return jsonify({"error": "initial must be > 0"}), 400
        return jsonify(simulate_portfolio(ngx_pct, initial))
    except ValueError:
        return jsonify({"error": "Invalid parameters"}), 400


@app.route("/api/all")
def api_all():
    """Single endpoint that returns everything — useful for the frontend to load once."""
    return jsonify({
        "market_data": MARKET_DATA,
        "stats":       STATS,
        "sectors":     {"ngx": NGX_SECTORS, "sp500": SP_SECTORS},
        "top_stocks":  {"ngx": NGX_TOP_STOCKS, "sp500": SP_TOP_STOCKS},
        "compare":     COMPARE_DATA,
        "roadmap":     ROADMAP,
    })


# ─────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────
if __name__ == "__main__":
    print("\n" + "=" * 56)
    print("  🇳🇬  Nigeria vs USA — Investment Dashboard")
    print("  Server: http://127.0.0.1:5000")
    print("  API:    http://127.0.0.1:5000/api/all")
    print("=" * 56 + "\n")
    app.run(debug=True, port=5000)
