import streamlit as st
import pandas as pd
import plotly.graph_objects as go
import base64

st.set_page_config(
    page_title="Smart Logistics Command Center",
    page_icon="🚚",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ---------------------------------------------------
# BACKGROUND VIDEO
# ---------------------------------------------------

def add_bg_video():
    video_file = open("video.mp4", "rb")
    video_bytes = video_file.read()
    video_base64 = base64.b64encode(video_bytes).decode()

    st.markdown(
        f"""
        <style>

        .stApp {{
            background: transparent;
        }}

        #bg-video {{
            position: fixed;
            right: 0;
            bottom: 0;
            min-width: 100%;
            min-height: 100%;
            object-fit: cover;
            z-index: -1;
        }}

        </style>

        <video autoplay muted loop id="bg-video">
        <source src="data:video/mp4;base64,{video_base64}" type="video/mp4">
        </video>
        """,
        unsafe_allow_html=True
    )

add_bg_video()

# ---------------------------------------------------
# SESSION STATE
# ---------------------------------------------------

if "active_panel" not in st.session_state:
    st.session_state.active_panel = None

def open_panel(panel):
    st.session_state.active_panel = panel

# ---------------------------------------------------
# UI STYLE
# ---------------------------------------------------

st.markdown("""
<style>

.stApp{
background:transparent;
color:white;
font-family:'Segoe UI',sans-serif;
}

/* PREMIUM TITLE */

.main-title{
font-size:90px;
font-weight:800;
letter-spacing:3px;
background:linear-gradient(90deg,#ffffff,#e2e8f0,#93c5fd);
-webkit-background-clip:text;
-webkit-text-fill-color:transparent;
text-shadow:0 10px 40px rgba(0,0,0,0.6);
margin-bottom:10px;
}

/* GLASS CARDS */

.glass-card{
background:rgba(255,255,255,0.15);
backdrop-filter:blur(25px);
border-radius:20px;
border:1px solid rgba(255,255,255,0.25);
padding:22px;
margin-bottom:14px;
box-shadow:0 20px 60px rgba(0,0,0,0.5);
transition:all .35s ease;
}

.glass-card:hover{
transform:translateY(-8px) scale(1.03);
box-shadow:0 35px 100px rgba(0,0,0,0.7);
}

/* ALERT BADGE */

.alert-badge{
background:rgba(255,120,120,.25);
padding:7px 14px;
border-radius:12px;
color:white;
font-size:.9rem;
font-weight:500;
backdrop-filter:blur(10px);
}

[data-testid="stSidebar"]{
background:transparent;
border-right:none;
}

</style>
""", unsafe_allow_html=True)

# ---------------------------------------------------
# MOCK DATA
# ---------------------------------------------------

selected_area="Mumbai, India"

disruptions=[
{"headline":"Protest blocking NH-48","location":"Mumbai-Pune Expy","impact":"High","time":"10m ago"},
{"headline":"Port Strike at Nhava Sheva","location":"JNPT Port","impact":"Medium","time":"45m ago"},
{"headline":"Flash Flood Warning","location":"Thane Creek","impact":"High","time":"1h ago"}
]

warehouse_data=pd.DataFrame({
"Warehouse":["Mumbai Central","Navi Mumbai Hub","Thane Storage"],
"Current Stock":[1200,850,2100],
"Expected Shipments":[500,300,1200],
"Delay Risk":["Low","Medium","High"]
})

# ---------------------------------------------------
# SIDEBAR
# ---------------------------------------------------

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

# ---------------------------------------------------
# DASHBOARD
# ---------------------------------------------------

if menu=="Dashboard":

    col1,col2,col3=st.columns([1,2,1])

    with col1:
        st.markdown('<h1 class="main-title">Smart Logistics</h1>', unsafe_allow_html=True)

    with col2:
        st.markdown(f"**Current Location:** {selected_area}")

    with col3:
        st.markdown("""
        <span class="alert-badge">⚠️ 3 Active Alerts</span>
        """,unsafe_allow_html=True)

    st.markdown("---")

    c1,c2,c3,c4=st.columns(4)

    with c1:
        if st.button("Open Weather Panel"):
            open_panel("weather")

        st.markdown("""
        <div class="glass-card">
        <h4>Weather Conditions</h4>
        <h2>28°C</h2>
        Heavy Rain Probability: 85%<br>
        Wind: 24 km/h
        </div>
        """,unsafe_allow_html=True)

    with c2:
        if st.button("Open Delay Panel"):
            open_panel("delay")

        st.markdown("""
        <div class="glass-card">
        <h4>AI Delay Prediction</h4>
        <h2 style="color:#ff8a8a;">78% Risk</h2>
        Shipment SH-102<br>
        Heavy Traffic + Rain
        </div>
        """,unsafe_allow_html=True)

    with c3:
        if st.button("Open Warehouse Panel"):
            open_panel("warehouse")

        st.markdown("""
        <div class="glass-card">
        <h4>Warehouse Status</h4>
        <h2 style="color:#4ade80;">92%</h2>
        Capacity Usage
        </div>
        """,unsafe_allow_html=True)

    with c4:
        if st.button("Open Alerts Panel"):
            open_panel("alerts")

        st.markdown("""
        <div class="glass-card">
        <h4 style="color:#ff6b6b;">Critical Alerts</h4>
        Shipment SH-210 may miss SLA
        </div>
        """,unsafe_allow_html=True)

# ---------------------------------------------------
# MAP + NEWS
# ---------------------------------------------------

    col5,col6=st.columns([2,1])

    with col5:

        st.subheader("Smart Route Map")

        fig=go.Figure()

        fig.add_trace(go.Scattermapbox(
        mode="lines",
        lon=[72.83,72.85,72.87],
        lat=[19.07,19.09,19.11],
        line=dict(width=6,color="#4f8cff")
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

        st.subheader("News Disruptions")

        for d in disruptions:
            st.markdown(f"""
            <div class="glass-card">
            <b>{d['headline']}</b><br>
            📍 {d['location']}<br>
            Impact: {d['impact']}<br>
            <small>{d['time']}</small>
            </div>
            """,unsafe_allow_html=True)

elif menu=="Route Planner":

    st.title("Route Planner")
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