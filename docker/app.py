from flask import Flask, request, render_template
import pandas as pd
import boto3
import io

app = Flask(__name__)

# Initialize S3 client
s3 = boto3.client('s3')

def load_data_from_s3(bucket_name, file_key):
    # Download file from S3
    obj = s3.get_object(Bucket=bucket_name, Key=file_key)
    data = obj['Body'].read()
    # Load data into pandas DataFrame
    df = pd.read_csv(io.BytesIO(data))
    return df

# Load dataset from S3
bucket_name = 'testapplicationhera'
file_key = 'Mobile_Food_Facility_Permit.csv'
df = load_data_from_s3(bucket_name, file_key)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/find-trucks', methods=['POST'])
def find_trucks():
    cuisine = request.form['cuisine']
    results = df[df['FoodItems'].str.contains(cuisine, case=False, na=False)]
    return render_template('results.html', trucks=results.to_dict(orient='records'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)

