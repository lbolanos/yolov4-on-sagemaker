FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates \
            git build-essential libopencv-dev \
      && apt install --no-install-recommends -y python3.8 python3-pip python3-setuptools python3-distutils \
      && rm -rf /var/lib/apt/lists/*
# wget \
RUN cd /opt && git clone https://github.com/AlexeyAB/darknet.git && cd darknet \
  && sed -i 's/OPENCV=0/OPENCV=1/' Makefile \
  && sed -i 's/GPU=0/GPU=1/' Makefile \
  && sed -i 's/CUDNN=0/CUDNN=1/' Makefile \
  && sed -i 's/LIBSO=0/LIBSO=1/' Makefile \
  && make OPENCV=1 GPU=1 AVX=1 OPENMP=1 CUDNN=1 CUDNN_HALF=0 OPENMP=1 LIBSO=1 -j $(nproc)

# pretained
# RUN mkdir -p /opt/darknet/weights \
# && cd /opt/darknet/weights

#&& wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-csp-x-swish.conv.192 \
#&& wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-p6.conv.289 \
#&& wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-csp-swish.conv.164 \
#&& wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v4_pre/yolov4-p5.conv.232

COPY main.py /opt/darknet/
WORKDIR /opt/darknet
ENTRYPOINT ["python3", "main.py"]

