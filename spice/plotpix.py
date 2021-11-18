import pandas as pd
import plotly.express as px

df = pd.read_csv("out.csv", delim_whitespace=True, names=["Time", "Reset", "t2", "Expose", "t3", "Out", "t4", "PG"])


print(df)
fig = px.line(df, x = "Time", y = ["Reset", "Expose", "Out", "PG"], template = "none")
fig.write_image("pixel.pdf")
