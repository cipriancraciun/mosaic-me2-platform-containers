#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test ! -e "${_outputs}/rootfs"
mkdir -m 0755 -- "${_outputs}/rootfs"


echo "[ii] installing core repositories..." >&2

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://download.opensuse.org/update/12.3 opensuse--updates--oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://download.opensuse.org/distribution/12.3/repo/oss opensuse--packages--oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://download.opensuse.org/update/12.3-non-oss opensuse--updates--non-oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://download.opensuse.org/distribution/12.3/repo/non-oss opensuse--packages--non-oss

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://ftp.info.uvt.ro/mos/opensuse/12.3/packages custom--packages--a

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_addrepo_arguments[@]}" \
		http://jenkins.ieat.ro/repos/development custom--packages--b

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_refresh_arguments[@]}"


echo "[ii] installing core packages..." >&2

setarch "${_linux_arch}" -- env -i "${_zypper_env[@]}" "${_zypper_bin}" "${_zypper_install_arguments[@]}" \
		base."${_zypper_arch}"


echo "[ii] configuring core packages..." >&2
cat >"${_outputs}/rootfs/etc/resolv.conf" <<EOS
search internal
nameserver 8.8.8.8
EOS


exit 0
