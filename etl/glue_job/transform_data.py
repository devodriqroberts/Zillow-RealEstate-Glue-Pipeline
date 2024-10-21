import sys

from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import functions as F
from pyspark.sql.functions import col, expr, first

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)


def extract_city_from_catalog(database, city_table_name):
    raw_city_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
        database=database, table_name=city_table_name
    )
    df = raw_city_dynamic_frame.toDF()
    return df

def drop_columns(df):
    # drop from table columns with struct type
    cols = ("listing_sub_type", "open_house_info")

    df_drops= df.drop(*cols)
    return df_drops


def group_data(df):
    #"group the data by zipcode"
    df_group = (
        df.groupBy("zipcode","state","city","country","currency")
        .agg(
            F.count("*").alias("Total Zipcodes"),
            F.avg("bathrooms").alias("avg_bathrooms"),
            F.avg("bedrooms").alias("avg_bedrooms"),
            F.mean(col("price") / col("livingArea")).alias("avg_price_per_sqft"),
        )
        .orderBy("zipcode")
    )
    return df_group


def load_to_s3(glue_dynamic_frame):
    s3output = glueContext.getSink(
        path="s3://droberts-zillow-real-estate-etl/processed-data/",
        connection_type="s3",
        updateBehavior="UPDATE_IN_DATABASE",
        partitionKeys=[],
        compression="snappy",
        enableUpdateCatalog=True,
        transformation_ctx="s3output",
    )

    s3output.setCatalogInfo(
        catalogDatabase="zillow-real-estate-database", catalogTableName="immo_report"
    )

    s3output.setFormat("glueparquet")
    s3output.writeFrame(glue_dynamic_frame)


if __name__ == "__main__":
    database    = "zillow-real-estate-database"
    table_name  = "immo_atlanta"

    df_city  = extract_city_from_catalog(database, table_name)
    
    df_drops = drop_columns(df_city)
    
    df_final = group_data(df_drops)

    # going from Spark dataframe to glue dynamic frame
    
    glue_dynamic_frame = DynamicFrame.fromDF(df_final, glueContext, "glue_etl")

    # load to s3
    load_to_s3(glue_dynamic_frame)
    
    job.commit()