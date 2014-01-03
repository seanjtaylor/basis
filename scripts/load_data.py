
import os
import json
import pandas as pd
from datetime import datetime, timedelta

def load_data(data_dir='data/raw'):
    
    dfs = []
    states = []
    for fn in sorted(os.listdir(data_dir)):
        
        path = os.path.join(data_dir, fn)
        with open(path) as f:
            obj = json.load(f)

        minutes = pd.date_range(
            pd.to_datetime(obj['starttime'], unit='s'),
            pd.to_datetime(obj['endtime'], unit='s'),
            tz='UTC',
            freq='min',
            ).tz_convert('US/Pacific')
        
        data = {'minutes': minutes}
        
        for metric in obj['metrics'].keys():
            data[metric] = obj['metrics'][metric]['values']
            
        dfs.append(pd.DataFrame(data))
        states.extend(obj['bodystates'])
        
    df = pd.concat(dfs)
    df['weekday'] = df['minutes'].apply(lambda x: x.weekday())
    df['hour'] = df['minutes'].apply(lambda x: x.hour)

    states = pd.DataFrame(states, columns=['start', 'end', 'activity'])
    
    return df, states

if __name__ == '__main__':
    df, states = load_data()
    df.to_csv('data/clean/metrics_10011230.csv')
    states.to_csv('data/clean/states_10011230.csv')
