FROM debian:bullseye@sha256:7b991788987ad860810df60927e1adbaf8e156520177bd4db82409f81dd3b721

ARG KERNEL_VERSION
ENV KERNEL_VERSION=${KERNEL_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y --fix-missing \
  && apt-get install -y build-essential git gcc-multilib wget flex bison bc libelf-dev zstd kmod rsync python3

WORKDIR /work
COPY build_kernel.sh /work/build_kernel.sh
COPY kernel.config /work/kernel.config
RUN ./build_kernel.sh -v "${KERNEL_VERSION}" -c kernel.config -w /work

VOLUME /output
CMD ["sh", "-c", "cp /work/pkg.tar.gz /output/linux-build-${KERNEL_VERSION}.tar.gz"]
