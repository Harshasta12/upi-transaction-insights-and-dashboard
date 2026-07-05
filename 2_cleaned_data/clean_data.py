import pandas as pd

# Load raw data
df = pd.read_csv(r'C:\Users\harsh\Downloads\raw_data.csv')

print(f"Original rows: {len(df)}")

# Remove duplicate transaction IDs
df = df.drop_duplicates(subset='transaction_id')
print(f"After removing duplicates: {len(df)}")

# Remove rows with blank amount or payment_method
df = df.dropna(subset=['amount', 'payment_method'])
print(f"After removing blank amount/payment_method: {len(df)}")

# Save cleaned file
df.to_csv('cleaned_data.csv', index=False)
print("Saved as cleaned_data.csv")