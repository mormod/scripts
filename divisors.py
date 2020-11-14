import sys

prediv_async_upper = pow(2, 7)
prediv_async_lower= 1

prediv_sync_upper = pow(2, 15)
prediv_sync_lower = 0

# in hz
input_freq = 32768
wanted_freq = 1
ppm_avg_error = 0
prescaler_hse = 1

if len(sys.argv) >= 2:
    input_freq = int(sys.argv[1])
if len(sys.argv) >= 3:
    ppm_avg_error = int(sys.argv[2])
if len(sys.argv) >= 4:
    prescaler_hse = int(sys.argv[3])

print('============================================================')
print('AVAILABLE PRESCALERS (PERFECT OSZ)'.center(60))
print(f'input_freq = {input_freq}, prescaler_hse = {prescaler_hse}')

ppm_avg_error_scaled = ppm_avg_error / 10**6
freq_error = (input_freq * ppm_avg_error_scaled) / prescaler_hse
scaled_input_freq = input_freq / prescaler_hse

print(f'scaled input_freq = {scaled_input_freq}')

print()
print('------------------------------------------------------------')
print('ck_spre'.rjust(10), 'PREDIV_A'.rjust(10), 'PREDIV_B'.ljust(10))

closest = prediv_sync_upper
best_syn = 0
best_asy = 0
needed_approx = True
for syn in range(prediv_sync_lower, prediv_sync_upper):
    for asy in range(prediv_async_upper - 1, prediv_async_lower - 1, -1):
        ck_spre = scaled_input_freq / ((asy + 1) * (syn + 1))
        if ck_spre == wanted_freq:
            print(repr(ck_spre).rjust(10), repr(asy).rjust(10), repr(syn).ljust(10))
            needed_approx = False
        elif abs(ck_spre - wanted_freq) < closest:
            closest = abs(ck_spre - wanted_freq)
            best_syn = syn
            best_asy = asy

if needed_approx:
    print(repr(round(closest, 7)).rjust(10), repr(best_asy).rjust(10), repr(best_syn).ljust(10), 'APPROX'.rjust(10))
print('------------------------------------------------------------')

"""
print()
print('============================================================')
print('AVAILABLE PRESCALERS (FLAWED OSZ)'.center(60))
print(f'scaled_input_freq = {scaled_input_freq}, ppm_error = {ppm_avg_error*1000000}')
print(f'freq_error = {freq_error} 1/(10^6 s)')
print()
print('------------------------------------------------------------')
print('ck_spre'.rjust(10), 'PREDIV_A'.rjust(10), 'PREDIV_B'.ljust(10))

closest_diff = prediv_sync_upper
best_syn = 0
best_asy = 0
for syn in range(prediv_sync_lower, prediv_sync_upper):
    for asy in range(prediv_async_upper - 1, prediv_async_lower - 1, -1):
        ck_spre = (scaled_input_freq + freq_error) / ((asy + 1) * (syn + 1))
        tmp = abs(1 - ck_spre)
        if tmp < closest_diff:
            closest_diff = tmp
            best_asy = asy
            best_syn = syn

print(repr(round(1+closest_diff, 7)).rjust(10), repr(best_asy).rjust(10), repr(best_syn).ljust(10))
print('------------------------------------------------------------')

one_sec_time = wanted_freq/(1+closest_diff)
day_sec_error = (1 - one_sec_time) * (24 * 60 * 60)

print()
print(f'=> one counted second lasts {one_sec_time}s')
print(f'=> error per 24h: ', repr(round(day_sec_error, 18)).ljust(20), 's'.rjust(5))
print(f'=>'.ljust(18), repr(round(day_sec_error / 60, 18)).ljust(20), 'min'.rjust(5))
print(f'=>'.ljust(18), repr(round(day_sec_error / 60 / 60, 18)).ljust(20), 'h'.rjust(5)) 
print(f'=>'.ljust(18), repr(round(day_sec_error / 60 / 60 / 24, 18)).ljust(20), 'd'.rjust(5))
"""

print('============================================================')
print('FLAWED OSC AVG'.center(60))
print(f'scaled_input_freq = {scaled_input_freq}, ppm_error = {ppm_avg_error}')
print()
print('------------------------------------------------------------')
print('ppm_error'.rjust(10), 'ck_spre'.rjust(20), 'PREDIV_A'.rjust(10), 'PREDIV_B'.ljust(10))

closest_diff = prediv_sync_upper
best_syn = 0
best_asy = 0
best_approxes = []
for i in range(1, ppm_avg_error, int(ppm_avg_error / 200) + 1):
    freq_error = (input_freq * (i / 10**6)) / prescaler_hse
    for syn in range(prediv_sync_lower, prediv_sync_upper):
        for asy in range(prediv_async_upper - 1, prediv_async_lower - 1, -1):
            ck_spre = (scaled_input_freq + freq_error) / ((asy + 1) * (syn + 1))
            tmp = abs(1 - ck_spre)
            if tmp < closest_diff:
                closest_diff = tmp
                best_asy = asy
                best_syn = syn
    best_approxes.append(1+closest)
    print(repr(i).rjust(10), repr((1+closest_diff)).rjust(20), repr(best_asy).rjust(10), repr(best_syn).ljust(10))


print('------------------------------------------------------------')

#one_sec_time = wanted_freq/(1+closest_diff)
one_sec_time_sum = 0
for d in best_approxes:
    one_sec_time_sum += wanted_freq / d

one_sec_time_avg = one_sec_time_sum / len(best_approxes)
day_sec_error = (1 - one_sec_time_avg) * (24 * 60 * 60)

print()
print(f'=> one counted second lasts {one_sec_time_avg}s')
print(f'=> error per 24h: ', repr(round(day_sec_error, 18)).ljust(20), 's'.rjust(5))
print(f'=>'.ljust(18), repr(round(day_sec_error / 60, 18)).ljust(20), 'min'.rjust(5))
print(f'=>'.ljust(18), repr(round(day_sec_error / 60 / 60, 18)).ljust(20), 'h'.rjust(5)) 
print(f'=>'.ljust(18), repr(round(day_sec_error / 60 / 60 / 24, 18)).ljust(20), 'd'.rjust(5))