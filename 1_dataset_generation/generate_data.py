import pandas as pd
import random
from faker import Faker
from datetime import datetime, timedelta

fake = Faker('en_IN')
random.seed(42)

NUM_ROWS = 10000

payment_methods = ['UPI', 'Card', 'Wallet', 'Net Banking']
merchant_categories = ['Food & Dining', 'Retail', 'Bill Payments', 'Travel', 'Entertainment', 'Healthcare', 'Education', 'Groceries']
city_tiers = ['Tier 1', 'Tier 2', 'Tier 3']
device_types = ['Android', 'iOS', 'Web']
statuses = ['Success', 'Failed', 'Pending']
failure_reasons = ['Timeout', 'Bank Declined', 'Wrong PIN', 'Insufficient Funds', 'Network Error', None]

# Weights to make data realistic
status_weights = [0.72, 0.22, 0.06]
payment_weights = [0.55, 0.20, 0.15, 0.10]
tier_weights = [0.45, 0.35, 0.20]

start_date = datetime(2024, 1, 1)
end_date = datetime(2024, 12, 31)

user_ids = [f'USR{str(i).zfill(5)}' for i in range(1, 2001)]
user_first_month = {uid: random.randint(1, 6) for uid in user_ids}

rows = []

for i in range(NUM_ROWS):
    txn_id = f'TXN{str(i+1).zfill(7)}'
    user_id = random.choice(user_ids)
    txn_date = start_date + timedelta(days=random.randint(0, 364), hours=random.randint(0, 23), minutes=random.randint(0, 59))
    amount = round(random.choices(
        [random.uniform(10, 500), random.uniform(500, 5000), random.uniform(5000, 50000)],
        weights=[0.65, 0.25, 0.10]
    )[0], 2)
    payment_method = random.choices(payment_methods, weights=payment_weights)[0]
    merchant_category = random.choice(merchant_categories)
    city_tier = random.choices(city_tiers, weights=tier_weights)[0]
    device_type = random.choice(device_types)
    status = random.choices(statuses, weights=status_weights)[0]

    if status == 'Failed':
        failure_reason = random.choice([r for r in failure_reasons if r is not None])
    else:
        failure_reason = None

    is_new_user = 'Yes' if txn_date.month == user_first_month[user_id] else 'No'
    first_txn_month = datetime(2024, user_first_month[user_id], 1).strftime('%Y-%m')

    # Introduce intentional mess for cleaning exercise
    if random.random() < 0.03:
        status = random.choice(['Sucess', 'failed', 'PENDING'])
    if random.random() < 0.02:
        amount = None
    if random.random() < 0.02:
        payment_method = None
    if random.random() < 0.015:
        txn_id = f'TXN{str(random.randint(1, i+1)).zfill(7)}'  # duplicate

    rows.append([
        txn_id, user_id, txn_date.strftime('%Y-%m-%d %H:%M:%S'),
        amount, payment_method, merchant_category,
        city_tier, device_type, status, failure_reason,
        is_new_user, first_txn_month
    ])

columns = [
    'transaction_id', 'user_id', 'transaction_date', 'amount',
    'payment_method', 'merchant_category', 'city_tier', 'device_type',
    'status', 'failure_reason', 'is_new_user', 'first_transaction_month'
]

df = pd.DataFrame(rows, columns=columns)
df.to_csv('raw_data.csv', index=False)
print(f"Dataset generated: {len(df)} rows")
print(df.head())