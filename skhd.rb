class Skhd < Formula
  desc "Simple hotkey-daemon for macOS."
  homepage "https://github.com/koekeishiya/skhd"
  head "https://github.com/hunterliao29/skhd.git"

  option "with-logging", "Redirect stdout and stderr to log files"

  def install
    (var/"log/skhd").mkpath
    system "make", "install"
    bin.install "#{buildpath}/bin/skhd"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    If the formula has been built with --with-logging, logs will be found in
      #{var}/log/skhd/skhd.[out|err].log
    EOS
  end

  if build.with? "logging"
    service do
      run "#{opt_bin}/skhd"
      environment_variables PATH: std_service_path_env
      keep_alive true
      log_path "#{var}/log/skhd/skhd.out.log"
      error_log_path "#{var}/log/skhd/skhd.err.log"
      process_type :interactive
    end 
  else
    service do
      run "#{opt_bin}/skhd"
      environment_variables PATH: std_service_path_env
      keep_alive true
      process_type :interactive
    end 
  end

  test do
    assert_match "skhd #{version}", shell_output("#{bin}/skhd --version")
  end
end
