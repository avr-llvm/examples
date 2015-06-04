; ModuleID = 'fourierf.c'
target datalayout = "e-p:16:8:8-i8:8:8-i16:8:8-i32:8:8-i64:8:8-f32:8:8-f64:8:8-n8"
target triple = "avr"

%struct.__file = type { i8*, i8, i8, i16, i16, i16 (i8, %struct.__file*)*, i16 (%struct.__file*)*, i8* }

@__iob = external global [0 x %struct.__file*], align 2
@.str = private unnamed_addr constant [52 x i8] c"Error in fft():  NumSamples=%u is not power of two\0A\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"RealIn\00", align 1
@.str.2 = private unnamed_addr constant [8 x i8] c"RealOut\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"ImagOut\00", align 1
@.str.4 = private unnamed_addr constant [35 x i8] c"Error in fft_float():  %s == NULL\0A\00", align 1

; Function Attrs: nounwind
define void @fft_float(i16 %NumSamples, i16 %InverseTransform, float* %RealIn, float* %ImagIn, float* %RealOut, float* %ImagOut) #0 {
entry:
  %NumSamples.addr = alloca i16, align 2
  %InverseTransform.addr = alloca i16, align 2
  %RealIn.addr = alloca float*, align 2
  %ImagIn.addr = alloca float*, align 2
  %RealOut.addr = alloca float*, align 2
  %ImagOut.addr = alloca float*, align 2
  %NumBits = alloca i16, align 2
  %i = alloca i16, align 2
  %j = alloca i16, align 2
  %k = alloca i16, align 2
  %n = alloca i16, align 2
  %BlockSize = alloca i16, align 2
  %BlockEnd = alloca i16, align 2
  %angle_numerator = alloca double, align 8
  %tr = alloca double, align 8
  %ti = alloca double, align 8
  %delta_angle = alloca double, align 8
  %sm2 = alloca double, align 8
  %sm1 = alloca double, align 8
  %cm2 = alloca double, align 8
  %cm1 = alloca double, align 8
  %w = alloca double, align 8
  %ar = alloca [3 x double], align 8
  %ai = alloca [3 x double], align 8
  %temp = alloca double, align 8
  %denom = alloca double, align 8
  store i16 %NumSamples, i16* %NumSamples.addr, align 2
  store i16 %InverseTransform, i16* %InverseTransform.addr, align 2
  store float* %RealIn, float** %RealIn.addr, align 2
  store float* %ImagIn, float** %ImagIn.addr, align 2
  store float* %RealOut, float** %RealOut.addr, align 2
  store float* %ImagOut, float** %ImagOut.addr, align 2
  store double 0x401921FB54442D18, double* %angle_numerator, align 8
  %0 = load i16, i16* %NumSamples.addr, align 2
  %call = call i16 @IsPowerOfTwo(i16 %0)
  %tobool = icmp ne i16 %call, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %1 = load %struct.__file*, %struct.__file** getelementptr inbounds ([0 x %struct.__file*], [0 x %struct.__file*]* @__iob, i32 0, i16 2), align 2
  %2 = load i16, i16* %NumSamples.addr, align 2
  %call1 = call i16 (%struct.__file*, i8*, ...) @fprintf(%struct.__file* %1, i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str, i32 0, i32 0), i16 %2)
  call void @exit(i16 1) #4
  unreachable

if.end:                                           ; preds = %entry
  %3 = load i16, i16* %InverseTransform.addr, align 2
  %tobool2 = icmp ne i16 %3, 0
  br i1 %tobool2, label %if.then.3, label %if.end.4

if.then.3:                                        ; preds = %if.end
  %4 = load double, double* %angle_numerator, align 8
  %sub = fsub double -0.000000e+00, %4
  store double %sub, double* %angle_numerator, align 8
  br label %if.end.4

if.end.4:                                         ; preds = %if.then.3, %if.end
  %5 = load float*, float** %RealIn.addr, align 2
  %6 = bitcast float* %5 to i8*
  call void @CheckPointer(i8* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i32 0, i32 0))
  %7 = load float*, float** %RealOut.addr, align 2
  %8 = bitcast float* %7 to i8*
  call void @CheckPointer(i8* %8, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.2, i32 0, i32 0))
  %9 = load float*, float** %ImagOut.addr, align 2
  %10 = bitcast float* %9 to i8*
  call void @CheckPointer(i8* %10, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i32 0, i32 0))
  %11 = load i16, i16* %NumSamples.addr, align 2
  %call5 = call i16 @NumberOfBitsNeeded(i16 %11)
  store i16 %call5, i16* %NumBits, align 2
  store i16 0, i16* %i, align 2
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end.4
  %12 = load i16, i16* %i, align 2
  %13 = load i16, i16* %NumSamples.addr, align 2
  %cmp = icmp ult i16 %12, %13
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %14 = load i16, i16* %i, align 2
  %15 = load i16, i16* %NumBits, align 2
  %call6 = call i16 @ReverseBits(i16 %14, i16 %15)
  store i16 %call6, i16* %j, align 2
  %16 = load i16, i16* %i, align 2
  %17 = load float*, float** %RealIn.addr, align 2
  %arrayidx = getelementptr inbounds float, float* %17, i16 %16
  %18 = load float, float* %arrayidx, align 4
  %19 = load i16, i16* %j, align 2
  %20 = load float*, float** %RealOut.addr, align 2
  %arrayidx7 = getelementptr inbounds float, float* %20, i16 %19
  store float %18, float* %arrayidx7, align 4
  %21 = load float*, float** %ImagIn.addr, align 2
  %cmp8 = icmp eq float* %21, null
  br i1 %cmp8, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body
  br label %cond.end

cond.false:                                       ; preds = %for.body
  %22 = load i16, i16* %i, align 2
  %23 = load float*, float** %ImagIn.addr, align 2
  %arrayidx9 = getelementptr inbounds float, float* %23, i16 %22
  %24 = load float, float* %arrayidx9, align 4
  %conv = fpext float %24 to double
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi double [ 0.000000e+00, %cond.true ], [ %conv, %cond.false ]
  %conv10 = fptrunc double %cond to float
  %25 = load i16, i16* %j, align 2
  %26 = load float*, float** %ImagOut.addr, align 2
  %arrayidx11 = getelementptr inbounds float, float* %26, i16 %25
  store float %conv10, float* %arrayidx11, align 4
  br label %for.inc

for.inc:                                          ; preds = %cond.end
  %27 = load i16, i16* %i, align 2
  %inc = add i16 %27, 1
  store i16 %inc, i16* %i, align 2
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i16 1, i16* %BlockEnd, align 2
  store i16 2, i16* %BlockSize, align 2
  br label %for.cond.12

for.cond.12:                                      ; preds = %for.inc.98, %for.end
  %28 = load i16, i16* %BlockSize, align 2
  %29 = load i16, i16* %NumSamples.addr, align 2
  %cmp13 = icmp ule i16 %28, %29
  br i1 %cmp13, label %for.body.15, label %for.end.99

for.body.15:                                      ; preds = %for.cond.12
  %30 = load double, double* %angle_numerator, align 8
  %31 = load i16, i16* %BlockSize, align 2
  %conv16 = uitofp i16 %31 to double
  %div = fdiv double %30, %conv16
  store double %div, double* %delta_angle, align 8
  %32 = load double, double* %delta_angle, align 8
  %mul = fmul double -2.000000e+00, %32
  %call17 = call double @sin(double %mul) #5
  store double %call17, double* %sm2, align 8
  %33 = load double, double* %delta_angle, align 8
  %sub18 = fsub double -0.000000e+00, %33
  %call19 = call double @sin(double %sub18) #5
  store double %call19, double* %sm1, align 8
  %34 = load double, double* %delta_angle, align 8
  %mul20 = fmul double -2.000000e+00, %34
  %call21 = call double @cos(double %mul20) #5
  store double %call21, double* %cm2, align 8
  %35 = load double, double* %delta_angle, align 8
  %sub22 = fsub double -0.000000e+00, %35
  %call23 = call double @cos(double %sub22) #5
  store double %call23, double* %cm1, align 8
  %36 = load double, double* %cm1, align 8
  %mul24 = fmul double 2.000000e+00, %36
  store double %mul24, double* %w, align 8
  store i16 0, i16* %i, align 2
  br label %for.cond.25

for.cond.25:                                      ; preds = %for.inc.95, %for.body.15
  %37 = load i16, i16* %i, align 2
  %38 = load i16, i16* %NumSamples.addr, align 2
  %cmp26 = icmp ult i16 %37, %38
  br i1 %cmp26, label %for.body.28, label %for.end.97

for.body.28:                                      ; preds = %for.cond.25
  %39 = load double, double* %cm2, align 8
  %arrayidx29 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 2
  store double %39, double* %arrayidx29, align 8
  %40 = load double, double* %cm1, align 8
  %arrayidx30 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 1
  store double %40, double* %arrayidx30, align 8
  %41 = load double, double* %sm2, align 8
  %arrayidx31 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 2
  store double %41, double* %arrayidx31, align 8
  %42 = load double, double* %sm1, align 8
  %arrayidx32 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 1
  store double %42, double* %arrayidx32, align 8
  %43 = load i16, i16* %i, align 2
  store i16 %43, i16* %j, align 2
  store i16 0, i16* %n, align 2
  br label %for.cond.33

for.cond.33:                                      ; preds = %for.inc.91, %for.body.28
  %44 = load i16, i16* %n, align 2
  %45 = load i16, i16* %BlockEnd, align 2
  %cmp34 = icmp ult i16 %44, %45
  br i1 %cmp34, label %for.body.36, label %for.end.94

for.body.36:                                      ; preds = %for.cond.33
  %46 = load double, double* %w, align 8
  %arrayidx37 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 1
  %47 = load double, double* %arrayidx37, align 8
  %mul38 = fmul double %46, %47
  %arrayidx39 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 2
  %48 = load double, double* %arrayidx39, align 8
  %sub40 = fsub double %mul38, %48
  %arrayidx41 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 0
  store double %sub40, double* %arrayidx41, align 8
  %arrayidx42 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 1
  %49 = load double, double* %arrayidx42, align 8
  %arrayidx43 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 2
  store double %49, double* %arrayidx43, align 8
  %arrayidx44 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 0
  %50 = load double, double* %arrayidx44, align 8
  %arrayidx45 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 1
  store double %50, double* %arrayidx45, align 8
  %51 = load double, double* %w, align 8
  %arrayidx46 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 1
  %52 = load double, double* %arrayidx46, align 8
  %mul47 = fmul double %51, %52
  %arrayidx48 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 2
  %53 = load double, double* %arrayidx48, align 8
  %sub49 = fsub double %mul47, %53
  %arrayidx50 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 0
  store double %sub49, double* %arrayidx50, align 8
  %arrayidx51 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 1
  %54 = load double, double* %arrayidx51, align 8
  %arrayidx52 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 2
  store double %54, double* %arrayidx52, align 8
  %arrayidx53 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 0
  %55 = load double, double* %arrayidx53, align 8
  %arrayidx54 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 1
  store double %55, double* %arrayidx54, align 8
  %56 = load i16, i16* %j, align 2
  %57 = load i16, i16* %BlockEnd, align 2
  %add = add i16 %56, %57
  store i16 %add, i16* %k, align 2
  %arrayidx55 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 0
  %58 = load double, double* %arrayidx55, align 8
  %59 = load i16, i16* %k, align 2
  %60 = load float*, float** %RealOut.addr, align 2
  %arrayidx56 = getelementptr inbounds float, float* %60, i16 %59
  %61 = load float, float* %arrayidx56, align 4
  %conv57 = fpext float %61 to double
  %mul58 = fmul double %58, %conv57
  %arrayidx59 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 0
  %62 = load double, double* %arrayidx59, align 8
  %63 = load i16, i16* %k, align 2
  %64 = load float*, float** %ImagOut.addr, align 2
  %arrayidx60 = getelementptr inbounds float, float* %64, i16 %63
  %65 = load float, float* %arrayidx60, align 4
  %conv61 = fpext float %65 to double
  %mul62 = fmul double %62, %conv61
  %sub63 = fsub double %mul58, %mul62
  store double %sub63, double* %tr, align 8
  %arrayidx64 = getelementptr inbounds [3 x double], [3 x double]* %ar, i32 0, i16 0
  %66 = load double, double* %arrayidx64, align 8
  %67 = load i16, i16* %k, align 2
  %68 = load float*, float** %ImagOut.addr, align 2
  %arrayidx65 = getelementptr inbounds float, float* %68, i16 %67
  %69 = load float, float* %arrayidx65, align 4
  %conv66 = fpext float %69 to double
  %mul67 = fmul double %66, %conv66
  %arrayidx68 = getelementptr inbounds [3 x double], [3 x double]* %ai, i32 0, i16 0
  %70 = load double, double* %arrayidx68, align 8
  %71 = load i16, i16* %k, align 2
  %72 = load float*, float** %RealOut.addr, align 2
  %arrayidx69 = getelementptr inbounds float, float* %72, i16 %71
  %73 = load float, float* %arrayidx69, align 4
  %conv70 = fpext float %73 to double
  %mul71 = fmul double %70, %conv70
  %add72 = fadd double %mul67, %mul71
  store double %add72, double* %ti, align 8
  %74 = load i16, i16* %j, align 2
  %75 = load float*, float** %RealOut.addr, align 2
  %arrayidx73 = getelementptr inbounds float, float* %75, i16 %74
  %76 = load float, float* %arrayidx73, align 4
  %conv74 = fpext float %76 to double
  %77 = load double, double* %tr, align 8
  %sub75 = fsub double %conv74, %77
  %conv76 = fptrunc double %sub75 to float
  %78 = load i16, i16* %k, align 2
  %79 = load float*, float** %RealOut.addr, align 2
  %arrayidx77 = getelementptr inbounds float, float* %79, i16 %78
  store float %conv76, float* %arrayidx77, align 4
  %80 = load i16, i16* %j, align 2
  %81 = load float*, float** %ImagOut.addr, align 2
  %arrayidx78 = getelementptr inbounds float, float* %81, i16 %80
  %82 = load float, float* %arrayidx78, align 4
  %conv79 = fpext float %82 to double
  %83 = load double, double* %ti, align 8
  %sub80 = fsub double %conv79, %83
  %conv81 = fptrunc double %sub80 to float
  %84 = load i16, i16* %k, align 2
  %85 = load float*, float** %ImagOut.addr, align 2
  %arrayidx82 = getelementptr inbounds float, float* %85, i16 %84
  store float %conv81, float* %arrayidx82, align 4
  %86 = load double, double* %tr, align 8
  %87 = load i16, i16* %j, align 2
  %88 = load float*, float** %RealOut.addr, align 2
  %arrayidx83 = getelementptr inbounds float, float* %88, i16 %87
  %89 = load float, float* %arrayidx83, align 4
  %conv84 = fpext float %89 to double
  %add85 = fadd double %conv84, %86
  %conv86 = fptrunc double %add85 to float
  store float %conv86, float* %arrayidx83, align 4
  %90 = load double, double* %ti, align 8
  %91 = load i16, i16* %j, align 2
  %92 = load float*, float** %ImagOut.addr, align 2
  %arrayidx87 = getelementptr inbounds float, float* %92, i16 %91
  %93 = load float, float* %arrayidx87, align 4
  %conv88 = fpext float %93 to double
  %add89 = fadd double %conv88, %90
  %conv90 = fptrunc double %add89 to float
  store float %conv90, float* %arrayidx87, align 4
  br label %for.inc.91

for.inc.91:                                       ; preds = %for.body.36
  %94 = load i16, i16* %j, align 2
  %inc92 = add i16 %94, 1
  store i16 %inc92, i16* %j, align 2
  %95 = load i16, i16* %n, align 2
  %inc93 = add i16 %95, 1
  store i16 %inc93, i16* %n, align 2
  br label %for.cond.33

for.end.94:                                       ; preds = %for.cond.33
  br label %for.inc.95

for.inc.95:                                       ; preds = %for.end.94
  %96 = load i16, i16* %BlockSize, align 2
  %97 = load i16, i16* %i, align 2
  %add96 = add i16 %97, %96
  store i16 %add96, i16* %i, align 2
  br label %for.cond.25

for.end.97:                                       ; preds = %for.cond.25
  %98 = load i16, i16* %BlockSize, align 2
  store i16 %98, i16* %BlockEnd, align 2
  br label %for.inc.98

for.inc.98:                                       ; preds = %for.end.97
  %99 = load i16, i16* %BlockSize, align 2
  %shl = shl i16 %99, 1
  store i16 %shl, i16* %BlockSize, align 2
  br label %for.cond.12

for.end.99:                                       ; preds = %for.cond.12
  %100 = load i16, i16* %InverseTransform.addr, align 2
  %tobool100 = icmp ne i16 %100, 0
  br i1 %tobool100, label %if.then.101, label %if.end.118

if.then.101:                                      ; preds = %for.end.99
  %101 = load i16, i16* %NumSamples.addr, align 2
  %conv102 = uitofp i16 %101 to double
  store double %conv102, double* %denom, align 8
  store i16 0, i16* %i, align 2
  br label %for.cond.103

for.cond.103:                                     ; preds = %for.inc.115, %if.then.101
  %102 = load i16, i16* %i, align 2
  %103 = load i16, i16* %NumSamples.addr, align 2
  %cmp104 = icmp ult i16 %102, %103
  br i1 %cmp104, label %for.body.106, label %for.end.117

for.body.106:                                     ; preds = %for.cond.103
  %104 = load double, double* %denom, align 8
  %105 = load i16, i16* %i, align 2
  %106 = load float*, float** %RealOut.addr, align 2
  %arrayidx107 = getelementptr inbounds float, float* %106, i16 %105
  %107 = load float, float* %arrayidx107, align 4
  %conv108 = fpext float %107 to double
  %div109 = fdiv double %conv108, %104
  %conv110 = fptrunc double %div109 to float
  store float %conv110, float* %arrayidx107, align 4
  %108 = load double, double* %denom, align 8
  %109 = load i16, i16* %i, align 2
  %110 = load float*, float** %ImagOut.addr, align 2
  %arrayidx111 = getelementptr inbounds float, float* %110, i16 %109
  %111 = load float, float* %arrayidx111, align 4
  %conv112 = fpext float %111 to double
  %div113 = fdiv double %conv112, %108
  %conv114 = fptrunc double %div113 to float
  store float %conv114, float* %arrayidx111, align 4
  br label %for.inc.115

for.inc.115:                                      ; preds = %for.body.106
  %112 = load i16, i16* %i, align 2
  %inc116 = add i16 %112, 1
  store i16 %inc116, i16* %i, align 2
  br label %for.cond.103

for.end.117:                                      ; preds = %for.cond.103
  br label %if.end.118

if.end.118:                                       ; preds = %for.end.117, %for.end.99
  ret void
}

declare i16 @IsPowerOfTwo(i16) #1

declare i16 @fprintf(%struct.__file*, i8*, ...) #1

; Function Attrs: noreturn
declare void @exit(i16) #2

; Function Attrs: nounwind
define internal void @CheckPointer(i8* %p, i8* %name) #0 {
entry:
  %p.addr = alloca i8*, align 2
  %name.addr = alloca i8*, align 2
  store i8* %p, i8** %p.addr, align 2
  store i8* %name, i8** %name.addr, align 2
  %0 = load i8*, i8** %p.addr, align 2
  %cmp = icmp eq i8* %0, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load %struct.__file*, %struct.__file** getelementptr inbounds ([0 x %struct.__file*], [0 x %struct.__file*]* @__iob, i32 0, i16 2), align 2
  %2 = load i8*, i8** %name.addr, align 2
  %call = call i16 (%struct.__file*, i8*, ...) @fprintf(%struct.__file* %1, i8* getelementptr inbounds ([35 x i8], [35 x i8]* @.str.4, i32 0, i32 0), i8* %2)
  call void @exit(i16 1) #4
  unreachable

if.end:                                           ; preds = %entry
  ret void
}

declare i16 @NumberOfBitsNeeded(i16) #1

declare i16 @ReverseBits(i16, i16) #1

; Function Attrs: nounwind readnone
declare double @sin(double) #3

; Function Attrs: nounwind readnone
declare double @cos(double) #3

attributes #0 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="atmega328p" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="atmega328p" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="atmega328p" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="atmega328p" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn }
attributes #5 = { nounwind readnone }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.7.0 (https://github.com/llvm-mirror/clang.git aebd4f6d15e44635ecc7338d4454389c4573bc2b) (https://github.com/llvm-mirror/llvm.git d5f64c2efbf855dc502ec0cfac1a202bc61c7bcf)"}
