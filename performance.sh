# 请切换到root用户

# CPU定频
echo "CPU0-3 可用频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo 1800000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_setspeed
echo "CPU0-3 当前频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq

echo "CPU4-5 可用频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
sudo echo 2400000 > /sys/devices/system/cpu/cpufreq/policy4/scaling_setspeed
echo "CPU4-5 当前频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/cpuinfo_cur_freq

echo "CPU6-7 可用频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy6/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
sudo echo 2400000 > /sys/devices/system/cpu/cpufreq/policy6/scaling_setspeed
echo "CPU6-7 当前频率:"
sudo cat /sys/devices/system/cpu/cpufreq/policy6/cpuinfo_cur_freq

# NPU定频
echo "NPU 可用频率:"
sudo cat /sys/class/devfreq/fdab0000.npu/available_frequencies    
sudo echo userspace > /sys/class/devfreq/fdab0000.npu/governor
sudo echo 1000000000 > /sys/class/devfreq/fdab0000.npu/userspace/set_freq
echo "NPU 当前频率:"
sudo cat /sys/class/devfreq/fdab0000.npu/cur_freq