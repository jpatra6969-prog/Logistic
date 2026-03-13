
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

st.set_page_config(
    page_title="Smart Logistics Command Center",
    page_icon="🚚",
    layout="wide",
    initial_sidebar_state="expanded"
)

# -------------------------------------------------------------------
# ULTRA MODERN UI STYLE
# -------------------------------------------------------------------

st.markdown("""
<style>

.stApp{
background:linear-gradient(270deg,#0f172a,#1e1b4b,#312e81,#1e3a8a);
background-size:800% 800%;
animation:gradientMove 18s ease infinite;
color:#e2e8f0;
font-family:'Inter',sans-serif;
}

@keyframes gradientMove{
0%{background-position:0% 50%}
50%{background-position:100% 50%}
100%{background-position:0% 50%}
}

header{visibility:hidden;}

.glass-card{
background:rgba(255,255,255,0.08);
backdrop-filter:blur(20px);
border-radius:18px;
border:1px solid rgba(255,255,255,0.15);
padding:22px;
margin-bottom:14px;
box-shadow:0 15px 50px rgba(0,0,0,0.5);
transition:all .35s ease;
animation:floatCard 6s ease-in-out infinite;
}

.glass-card:hover{
transform:translateY(-8px) scale(1.02);
box-shadow:0 30px 80px rgba(0,0,0,0.7);
border:1px solid rgba(255,255,255,0.35);
}

@keyframes floatCard{
0%{transform:translateY(0)}
50%{transform:translateY(-12px)}
100%{transform:translateY(0)}
}

.alert-badge{
background:rgba(239,68,68,.2);
padding:7px 12px;
border-radius:10px;
color:#fca5a5;
font-size:.8rem;
}

.pulse{
animation:pulse 2s infinite;
}

@keyframes pulse{
0%{box-shadow:0 0 0 0 rgba(239,68,68,.7);}
70%{box-shadow:0 0 0 18px rgba(239,68,68,0);}
100%{box-shadow:0 0 0 0 rgba(239,68,68,0);}
}

[data-testid="stSidebar"]{
background:#020617;
border-right:1px solid rgba(255,255,255,.05);
}

.delivery-rider{
position:fixed;
right:40px;
top:120px;
font-size:200px;
opacity:.95;
filter:drop-shadow(0 10px 60px rgba(0,0,0,.8));
animation:ride 6s ease-in-out infinite;
pointer-events:none;
}

@keyframes ride{
0%{transform:translateY(0px)}
50%{transform:translateY(-20px)}
100%{transform:translateY(0px)}
}

</style>

<div class="delivery-rider">🛵📦</div>

""", unsafe_allow_html=True)

# -------------------------------------------------------------------
# MOCK DATA
# -------------------------------------------------------------------

selected_area="Mumbai, India"

disruptions=[
{"headline":"Protest blocking NH-48","location":"Mumbai-Pune Expy","impact":"High","time":"10m ago"},
{"headline":"Port Strike at Nhava Sheva","location":"JNPT Port","impact":"Medium","time":"45m ago"},
{"headline":"Flash Flood Warning","location":"Thane Creek","impact":"High","time":"1h ago"}
]

traffic_data=pd.DataFrame({
"Road Name":["NH-48","Western Express Hwy","Sahar Rd","Mumbai-Pune Expy"],
"Traffic Level":["Heavy","Moderate","Clear","Heavy"],
"Est. Delay (min)":[45,15,5,60],
"Suggested Route":["Via Coastal Rd","Via Link Rd","N/A","Via Bypass"]
})

warehouse_data=pd.DataFrame({
"Warehouse":["Mumbai Central","Navi Mumbai Hub","Thane Storage"],
"Current Stock":[1200,850,2100],
"Expected Shipments":[500,300,1200],
"Delay Risk":["Low","Medium","High"]
})

# -------------------------------------------------------------------
# SIDEBAR
# -------------------------------------------------------------------

with st.sidebar:

    st.markdown("### 🚚 SmartLogistics")
    st.markdown("### Command Center")

    st.markdown("---")

    menu=st.radio(
        "Navigation",
        ["Dashboard","Route Planner","Analytics","Settings"],
        index=0
    )

    st.markdown("---")

    search_input=st.text_input("Enter City/Highway","Mumbai, India")

    if st.button("Scan Area"):
        with st.spinner("Scanning satellite data..."):
            st.rerun()

# -------------------------------------------------------------------
# DASHBOARD
# -------------------------------------------------------------------

if menu=="Dashboard":

    col1,col2,col3=st.columns([1,2,1])

    with col1:
        st.title("📍 Smart Logistics")

    with col2:
        st.markdown(f"**Current Location:** {selected_area}")

    with col3:
        st.markdown("""
        <div class="pulse">
        <span class="alert-badge">⚠️ 3 Active Alerts</span>
        </div>
        """,unsafe_allow_html=True)

    st.markdown("---")

# -------------------------------------------------------------------
# METRICS
# -------------------------------------------------------------------

    c1,c2,c3,c4=st.columns(4)

    with c1:
        st.markdown("""
        <div class="glass-card">
        <h4>Weather Conditions</h4>
        <h2>⛈️ 28°C</h2>
        Heavy Rain Probability: 85%<br>
        Wind: 24 km/h
        </div>
        """,unsafe_allow_html=True)

    with c2:
        st.markdown("""
        <div class="glass-card">
        <h4>AI Delay Prediction</h4>
        <h2 style="color:#f87171;">78% Risk</h2>
        Shipment SH-102<br>
        Heavy Traffic + Rain
        </div>
        """,unsafe_allow_html=True)

    with c3:
        st.markdown("""
        <div class="glass-card">
        <h4>Warehouse Status</h4>
        <h2 style="color:#34d399;">92%</h2>
        Capacity Usage
        </div>
        """,unsafe_allow_html=True)

    with c4:
        st.markdown("""
        <div class="glass-card">
        <h4 style="color:#ef4444;">Critical Alerts</h4>
        Shipment SH-210 may miss SLA
        </div>
        """,unsafe_allow_html=True)

# -------------------------------------------------------------------
# MAP + NEWS
# -------------------------------------------------------------------

    col5,col6=st.columns([2,1])

    with col5:

        st.subheader("🗺️ Smart Route Map")

        fig=go.Figure()

        # glowing route line
        fig.add_trace(go.Scattermapbox(
        mode="lines",
        lon=[72.83,72.85,72.87],
        lat=[19.07,19.09,19.11],
        line=dict(width=6,color="#3b82f6")
        ))

        # start + destination markers
        fig.add_trace(go.Scattermapbox(
        mode="markers",
        lon=[72.83,72.87],
        lat=[19.07,19.11],
        marker=dict(size=16,color=["#ef4444","#22c55e"])
        ))

        # truck icon in middle
        fig.add_trace(go.Scattermapbox(
        mode="markers+text",
        lon=[72.85],
        lat=[19.09],
        marker=dict(size=24,color="#f59e0b"),
        text=["🚚"],
        textfont=dict(size=24)
        ))

        fig.update_layout(
        mapbox_style="carto-darkmatter",
        mapbox_zoom=11,
        mapbox_center={"lat":19.09,"lon":72.85},
        height=400,
        margin={"r":0,"t":0,"l":0,"b":0},
        paper_bgcolor="rgba(0,0,0,0)"
        )

        st.plotly_chart(fig,use_container_width=True)

    with col6:

        st.subheader("📰 News Disruptions")

        for d in disruptions:

            st.markdown(f"""
            <div class="glass-card">
            <b>{d['headline']}</b><br>
            📍 {d['location']}<br>
            Impact: {d['impact']}<br>
            <small>{d['time']}</small>
            </div>
            """,unsafe_allow_html=True)

# -------------------------------------------------------------------
# TRAFFIC + ANALYTICS
# -------------------------------------------------------------------

    col7,col8=st.columns(2)

    with col7:
        st.subheader("🚦 Traffic Intelligence")
        st.dataframe(traffic_data,use_container_width=True)

    with col8:

        st.subheader("📊 Analytics Dashboard")

        chart_data=pd.DataFrame({
        "Route":["NH-48","Western Hwy","Sahar Rd","Mumbai-Pune"],
        "Delay":[45,20,10,60]
        })

        fig2=px.bar(
        chart_data,
        x="Route",
        y="Delay",
        color="Delay",
        color_continuous_scale="reds"
        )

        fig2.update_layout(
        paper_bgcolor="rgba(0,0,0,0)",
        plot_bgcolor="rgba(0,0,0,0)"
        )

        st.plotly_chart(fig2,use_container_width=True)

# -------------------------------------------------------------------
# WAREHOUSE
# -------------------------------------------------------------------

    st.subheader("🏭 Warehouse Monitoring")
    st.dataframe(warehouse_data,use_container_width=True)

elif menu=="Route Planner":

    st.title("🗺 Route Planner")
    st.map({"lat":[19.07,19.11],"lon":[72.87,72.90]})

elif menu=="Analytics":

    st.title("Analytics")
    st.line_chart(pd.DataFrame({
    "Day":["Mon","Tue","Wed","Thu","Fri"],
    "Disruptions":[2,5,3,8,4]
    }))

elif menu=="Settings":

    st.title("Settings")
    st.write("Configure system preferences")