import pandas as pd
import plotly.express as px

df = pd.read_csv("tmp.csv", delim_whitespace=True, names=["Time", "Input", "t2", "Output", "t3", "Comp"])

df.dropna(subset=["Comp"], inplace=True)
print(df)
fig = px.line(df, x = "Time", y = ["Input", "Output", "Comp"], template = "none")
fig.write_image("comp.pdf")
