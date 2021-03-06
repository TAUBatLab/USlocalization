function [ sig1 ,sig2 , sig3 , sig4  ] = SpeakersWaveformBuilder( mode, msg, window, freqs_mat, t, time, Fs, constelation_distance)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
switch(mode)
    case 0
        sig1= 5 * tts(msg,1);
        sig2= sig1;
        sig3= sig1;
        sig4= sig1;
    
    case 1
        wav1=tts('One',1);
        wav2=tts('Two',1);
        wav3=tts('Three',1);
        wav4=tts('Four',1);
        wav1(numel(wav4)) = 0;
        wav2(numel(wav4)) = 0;
        wav3(numel(wav4)) = 0;
        max_s = max([length(wav1),length(wav2),length(wav3),length(wav4)]);
        sig1 =  [wav1; zeros(1,max_s - length(wav1)).'];
        sig2 =  [wav2; zeros(1,max_s - length(wav2)).'];
        sig3 =  [wav3; zeros(1,max_s - length(wav3)).'];
        sig4 =  [wav4; zeros(1,max_s - length(wav4)).'];
        
    case 4
       ttt=0:1/Fs:0.01;
       sig1 = chirp4sp(ttt,0,0.01,60000);
       sig2= sig1;
       sig3= sig1;
       sig4= sig1;
       allchirp_ = [sig1 sig2 sig3 sig4];
       save('allchirps_channel_measurement.mat', 'allchirp_');
       
    case 5  % digital signal   
       sig1 = digital_sig(t, freqs_mat(1,1), constelation_distance, 4, Fs, 1);
       sig2 = digital_sig(t, freqs_mat(2,1), constelation_distance, 4, Fs, 1);
       sig3 = digital_sig(t, freqs_mat(3,1), constelation_distance, 4, Fs, 1);
       sig4 = digital_sig(t, freqs_mat(4,1), constelation_distance, 4, Fs, 1);
%        l = max([len(sig1),len(sig2),len(sig3),len(sig4)]);
%        sig1 = [sig1 zeros(1,l - len(sig1))];
%        sig2 = [sig2 zeros(1,l - len(sig2))];
%        sig3 = [sig3 zeros(1,l - len(sig3))];
%        sig4 = [sig4 zeros(1,l - len(sig4))];
       sig1=sig1.';
       sig2=sig2.';
       sig3=sig3.';
       sig4=sig4.';
       
       switch(window)
            case 'hamming'
                win = hamming(length(sig1));
            case 'linear_diagonal'
                win = linspace(1,0.02,length(sig1));
            case 'blackman_harris'
                win = blackmanharris(length(sig1));
            otherwise
                disp('no window - using box of ones');
                win = ones(length(sig1),1);
        end
        
        sig1 = sig1 .* win;
        sig2 = sig2 .* win;
        sig3 = sig3 .* win;
%         sig1 = zeros(251,1);
%         sig2 = zeros(251,1);
%         sig3 = zeros(251,1);
        sig4 = sig4 .* win;
       
    otherwise    
        switch msg
            case 'chirp'
                sig1 = chirp4sp(t,freqs_mat(1,2),time,freqs_mat(1,1));
                sig2 = chirp4sp(t,freqs_mat(2,2),time,freqs_mat(2,1));
                sig3 = chirp4sp(t,freqs_mat(3,2),time,freqs_mat(3,1));
                sig4 = chirp4sp(t,freqs_mat(4,2),time,freqs_mat(4,1));
            case 'radar_chirp'
                sig1 = UpAndDownchirp4sp(t, freqs_mat(1,1),time,freqs_mat(1,2),'up');
                sig2 = UpAndDownchirp4sp(t, freqs_mat(2,1),time,freqs_mat(2,2),'up');
                sig3 = UpAndDownchirp4sp(t, freqs_mat(3,1),time,freqs_mat(3,2),'up');
                sig4 = UpAndDownchirp4sp(t, freqs_mat(4,1),time,freqs_mat(4,2),'up');
            otherwise
                disp('wrong input');

        end
        switch(window)
            case 'hamming'
                win = hamming(length(sig1));
            case 'linear_diagonal'
                win = linspace(1,0.02,length(sig1));
            case 'blackman_harris'
                win = blackmanharris(length(sig1));
            otherwise
                disp('no window - using box of ones');
                win = ones(length(sig1),1);
        end
        
        sig1 = sig1 .* win;
        sig2 = sig2 .* win;
        sig3 = sig3 .* win;
%         sig1 = zeros(251,1);
%         sig2 = zeros(251,1);
%         sig3 = zeros(251,1);
        sig4 = sig4 .* win;
end

     allchirp = [sig1 sig2 sig3 sig4];
%     save('allchirps.mat', 'allchirp');
% 
    %plotting for debug
    a = allchirp(:,1);
    b = allchirp(:,2);
    c = allchirp(:,3);
    d = allchirp(:,4);
    figure; hold on; plot(t,a); %plot(t,b); plot(t,c); plot(t,d);
    title('Transmitted Signals [time domain]'); legend('sp1','sp2','sp3','sp4');
    xlabel('Time [sec]'); ylabel('Amplitude [V]');
    figure; hold on; plot(abs(xcorr(a,a))); plot(abs(xcorr(a,b)));plot(abs(xcorr(a,c))); plot(abs(xcorr(a,d))); %plot(xcorr(b,b));plot(xcorr(c,c));plot(xcorr(d,d));
    title('Autocorrelation vs Cross-correlation - Digital BFSK Signal'); legend('autocorrelation - sp1', 'Cross-correlation - sp1 , sp2','Cross-correlation - sp1 , sp3','Cross-correlation - sp1 , sp4'); %,'sp2','sp3','sp4');
    ylabel('Amplitude [V^2]');
%     figure; hold on; plot(xcorr(a,a));plot(xcorr(a,b));plot(xcorr(a,c));plot(xcorr(a,d));
%     title('Cross-correlation'); legend('sp1 - sp1','sp1 - sp2','sp1 - sp3','sp1 - sp4');


end

