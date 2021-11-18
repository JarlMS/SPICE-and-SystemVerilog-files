import pandas as pd
import plotly.express as px

df = pd.read_csv("tmp.csv", delim_whitespace=True, names=["Time", "Write", "t2", "Read", "t3", "Loop", "t4", "Data"])
print(df)
fig = px.line(df, x = "Time", y = ["Write", "Read", "Loop", "Data"], template = "none")
fig.write_image("memcell.pdf")
