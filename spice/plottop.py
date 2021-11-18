import pandas as pd
import plotly.express as px
import plotly.subplots as ps
import plotly.graph_objects as go

df = pd.read_csv("tmp.csv", delim_whitespace=True, names=["Time", "Reset", "t1", "Expose", "t2", "Pixel out", "t3", "PG", "t4", "Ramp", "t5", "Comp out", "t6", "Data", "t7", "Loop"])

#df.dropna(inplace=True)
print(df)

#df["Reset"] = pd.to_numeric(df["Reset"])
#df["Expose"] = pd.to_numeric(df["Expose"])
#df["Pixel out"] = pd.to_numeric(df["Pixel out"])
#df["PG"] = pd.to_numeric(df["PG"])
#df["Ramp"] = pd.to_numeric(df["Ramp"])
#df["Comp out"] = pd.to_numeric(df["Comp out"])
df["Data"] = pd.to_numeric(df["Data"])
#df["Loop"] = pd.to_numeric(df["Loop"])


figp = px.line(df, x = "Time", y = ["Reset", "Expose", "Pixel out"], width = 1000, height = 400, template = "none")
figp.write_image("spice_top_p1.pdf")

figc = px.line(df, x = "Time", y = ["Ramp", "Comp out", "Pixel out"], width = 1000, height = 400, template = "none")
figc.write_image("spice_top_c1.pdf")

figd = px.line(df, x = "Time", y = ["Data", "Comp out", "Loop"], width = 1000, height = 400, template = "none")
figd.write_image("spice_top_d1.pdf")

