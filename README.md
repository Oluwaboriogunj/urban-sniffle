# 🇳🇬 Nigeria vs USA — Investment Dashboard 2026

A full-stack interactive investment comparison dashboard built with:
- **Frontend**: Pure HTML + CSS + JavaScript (Chart.js)
- **Backend**: Python Flask REST API
- **Data**: Real market data sourced March 2026

---

## 📁 Project Structure

```
ngx_dashboard/
├── app.py               ← Flask backend server + all API endpoints
├── requirements.txt     ← Python dependencies
├── README.md            ← This file
├── templates/
│   └── index.html       ← Full interactive frontend (1,100+ lines)
└── static/              ← (empty — ready for your custom assets)
```

---

## 🚀 Quick Start

### Option A — With Flask (full-stack, recommended)

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Run the server
python app.py

# 3. Open in your browser
# → http://127.0.0.1:5000
```

### Option B — Static (no server needed)

Just open `templates/index.html` directly in your browser.
Everything works offline — Chart.js loads from CDN once on first load.

---

## 📊 Dashboard Features

### 6 Interactive Tabs

| Tab | Description |
|-----|-------------|
| 📈 **Charts** | 4 live Chart.js charts — annual returns (bar), indexed growth (line), real returns after inflation, inflation comparison. Real photos of Lagos & NYSE. |
| ⚖️ **Compare** | Full 12-row head-to-head table with color-coded winners. NGX vs S&P 500 verdict cards. |
| 🏦 **Sectors** | Two interactive donut charts showing NGX and S&P 500 sector weightings with hover tooltips. |
| 📊 **Top Stocks** | Dual-axis bar+line charts. 2025 returns (bars) + dividend yields (diamond markers) for top 5 stocks in each market. |
| 🔢 **Simulator** | **Live portfolio simulator.** Two sliders — NGX allocation % and initial investment. Chart + 4 summary value cards update in real time. |
| 🗺️ **Roadmap** | 7-step professional investor roadmap + investor suitability guide with badge labels. |

### Other Features
- **Ticker tape** scrolling across the top with real stock data
- **Hero banner** with real city photos (Lagos + New York)
- **Stat strip** with 10 key live metrics
- **Sticky tab navigation**
- **Film grain overlay** for depth
- **Fully responsive** — works on mobile
- **Lazy loading** — heavy chart tabs only render when clicked

---

## 🔌 REST API Endpoints

If running with Flask (`python app.py`):

| Endpoint | Description |
|----------|-------------|
| `GET /` | Serves the dashboard |
| `GET /api/all` | All data in one response |
| `GET /api/market-data` | Annual returns, inflation, FX data |
| `GET /api/stats` | Key headline statistics |
| `GET /api/sectors` | NGX + S&P sector breakdowns |
| `GET /api/top-stocks` | Top 5 stocks data for each market |
| `GET /api/compare` | Head-to-head comparison rows |
| `GET /api/roadmap` | 7-step investor roadmap data |
| `GET /api/simulate?ngx_pct=40&initial=10000` | Portfolio simulation |

### Simulate API Example
```bash
curl "http://127.0.0.1:5000/api/simulate?ngx_pct=40&initial=10000"
```
Returns:
```json
{
  "labels": [2019, 2020, 2021, 2022, 2023, 2024, 2025],
  "blend": [10000, 13160, ...],
  "sp100": [10000, 11840, ...],
  "ngx100": [10000, 15000, ...],
  "summary": {
    "initial": 10000,
    "final": 28450,
    "gain": 18450,
    "pct_gain": 184.5,
    "final_sp": 25000,
    "final_ngx": 32000,
    "vs_sp": 3450,
    "vs_ngx": -3550
  }
}
```

---

## 📈 Real Data Sources (March 2026)

| Data Point | Source | Value |
|------------|--------|-------|
| NGX 2025 return | NGX Group official report | +51.19% |
| NGX YTD 2026 | NGX Group (March 2026) | +27.5% |
| NGX market cap | NGX Group | ₦127.4 trillion |
| S&P 500 2025 return | First Trust / RBC Wealth | +17.9% |
| S&P 500 2025 peak | Market data | 6,932 (Dec 24, 2025) |
| S&P 500 market cap | Bloomberg | ~$61.1 trillion |
| Nigeria inflation | NBS / IMF | ~33% (2026) |
| US inflation | BLS / Fed | ~2.5% (2026) |
| Nigeria T-bill rate | CBN | ~20% |
| US T-bill rate | US Treasury | ~4.3% |

---

## ⚙️ Customisation

### Update market data
Edit the arrays at the top of `app.py`:
```python
NGX_RETURNS   = [50.0, 6.1, -17.0, 45.3, 35.0, 51.19]
SP500_RETURNS = [18.4, 28.7, -18.1, 26.3, 25.0, 17.9]
```

Or edit the JavaScript constants in `templates/index.html`:
```js
const D = {
  ngxR: [50.0, 6.1, -17.0, 45.3, 35.0, 51.19],
  spR:  [18.4, 28.7, -18.1, 26.3, 25.0, 17.9],
  ...
};
```

### Add your own photos
Place images in `static/` and update `<img src>` paths in `index.html`.

---

## ⚠️ Disclaimer

This dashboard is for **educational purposes only** and does not constitute
financial advice. Data is sourced from public market reports and may not
reflect real-time values. Currency-adjusted returns are estimates based on
approximate NGN/USD depreciation figures. Past performance is not indicative
of future results. Always consult a licensed financial advisor before making
investment decisions.

---

## 🛠️ Tech Stack

- **Python 3.10+** / **Flask 3.x**
- **Chart.js 4.4.1** (CDN)
- **Google Fonts** — Bebas Neue + DM Sans + DM Mono
- **Pexels** — stock photography
- Pure CSS (no framework) — custom design system with CSS variables
- Vanilla JavaScript — no framework needed
