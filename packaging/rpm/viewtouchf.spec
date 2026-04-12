Name:           viewtouchf
Version:        0.0.1
Release:        1%{?dist}
Summary:        ViewTouchF daemon

License:        MIT
URL:            https://github.com/No0ne558/ViewTouchF
Source0:        %{name}-%{version}.tar.gz

BuildArch:      %{_arch}
Requires:       sqlite-libs, openssl

%description
ViewTouchF point-of-sale daemon.

%prep
%setup -q

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt/viewtouchf/bin
cp -a opt/viewtouchf/bin/* %{buildroot}/opt/viewtouchf/bin/

%files
/opt/viewtouchf/bin/*

%changelog
