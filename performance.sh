# 请切换到root用户

# CPU定频
echo "CPU0-3可用频率/CPU6-7 available frequency:"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo 1800000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_setspeed
echo "CPU0-3当前频率/CPU0-3 current frequency:"
sudo cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq

echo "CPU4-5可用频率/CPU6-7 available frequency:"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
sudo echo 2400000 > /sys/devices/system/cpu/cpufreq/policy4/scaling_setspeed
echo "CPU4-5 当前频率/CPU4-5 current frequency:"
sudo cat /sys/devices/system/cpu/cpufreq/policy4/cpuinfo_cur_freq

echo "CPU6-7可用频率:/CPU6-7 available frequency"
sudo cat /sys/devices/system/cpu/cpufreq/policy6/scaling_available_frequencies
sudo echo userspace > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
sudo echo 2400000 > /sys/devices/system/cpu/cpufreq/policy6/scaling_setspeed
echo "CPU6-7 当前频率/CPU6-7 current frequency:"
sudo cat /sys/devices/system/cpu/cpufreq/policy6/cpuinfo_cur_freq

# NPU定频
echo "NPU可用频率/NPU available frequency:"
sudo cat /sys/class/devfreq/fdab0000.npu/available_frequencies    
sudo echo userspace > /sys/class/devfreq/fdab0000.npu/governor
sudo echo 1000000000 > /sys/class/devfreq/fdab0000.npu/userspace/set_freq
echo "NPU当前频率/NPU current frequency:"
sudo cat /sys/class/devfreq/fdab0000.npu/cur_freq
