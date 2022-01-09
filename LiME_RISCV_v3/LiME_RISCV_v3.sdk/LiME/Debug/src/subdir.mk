################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/platform.c \
../src/platform_zynq.c \
../src/udp_perf_server.c \
../src/utility.c 

CPP_SRCS += \
../src/core_single_cpu_lcg.cpp \
../src/randa.cpp 

OBJS += \
./src/core_single_cpu_lcg.o \
./src/platform.o \
./src/platform_zynq.o \
./src/randa.o \
./src/udp_perf_server.o \
./src/utility.o 

C_DEPS += \
./src/platform.d \
./src/platform_zynq.d \
./src/udp_perf_server.d \
./src/utility.d 

CPP_DEPS += \
./src/core_single_cpu_lcg.d \
./src/randa.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 g++ compiler'
	arm-none-eabi-g++ -DZYNQ -DHPL_CALL_VSIPL -DXILTIME -DSTANDALONE -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../LiME_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 g++ compiler'
	arm-none-eabi-g++ -DZYNQ -DHPL_CALL_VSIPL -DXILTIME -DSTANDALONE -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../LiME_bsp/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


