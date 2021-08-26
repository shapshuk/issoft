# import pip
# pip.main(['install','cmdbench'])
import cmdbench
import statistics
from cmdbench import benchmark_command, BenchmarkResults

# benchmark_results = BenchmarkResults()



# for _ in range(20):
#     new_benchmark_result = cmdbench.benchmark_command("stress --cpu 10 --timeout 5")
#     benchmark_results.add_benchmark_result(new_benchmark_result)
if __name__ == '__main__':
    benchmark_results = BenchmarkResults()
    # benchmark_results.add_benchmark_result(cmdbench.benchmark_command("python f:/Work/Python/ISSoft/Homework_4/test1.py", iterations_num = 10))

    for _ in range(5): 
        #  -regexp ^K -year_from 2000 -year_to 2005 -N 3 -genre \"War|Action\"
        # new_benchmark_result = cmdbench.benchmark_command("python f:/Work/Python/ISSoft/Homework_2/get-movies.py")
        new_benchmark_result = cmdbench.benchmark_command("sudo bash get-movies.sh")
        benchmark_results.add_benchmark_result(new_benchmark_result)

    # print(benchmark_results.get_averages())

    print('CPU: ', statistics.mean(benchmark_results.get_averages()['time_series']['cpu_percentages']))
    print('Memory: ', statistics.mean(benchmark_results.get_averages()['time_series']['memory_bytes'])/1024)
    print('Time (miliseconds): ', statistics.mean(benchmark_results.get_averages()['time_series']['sample_milliseconds']))

