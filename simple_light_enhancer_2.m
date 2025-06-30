function simple_light_enhancer
    fig = uifigure('Name', 'Filter Low Light', 'Position', [300 300 750 650]);

    ax1 = uiaxes(fig, 'Position', [30 150 320 320]);
    title(ax1, 'Gambar Asli / Frame Awal');
    axis(ax1, 'off');

    ax2 = uiaxes(fig, 'Position', [400 150 320 320]);
    title(ax2, 'Setelah Filter');
    axis(ax2, 'off');

    btnLoadImage = uibutton(fig, 'push', 'Text', 'Pilih Gambar', 'Position', [100 30 100 30], ...
        'ButtonPushedFcn', @(btn,event) loadImage());

    btnLoadVideo = uibutton(fig, 'push', 'Text', 'Pilih Video', 'Position', [220 30 100 30], ...
        'ButtonPushedFcn', @(btn,event) loadVideo());

    btnEnhance = uibutton(fig, 'push', 'Text', 'Perbaiki Gambar/Video Gelap', ...
        'Position', [460 30 180 30], 'Enable', 'off', ...
        'ButtonPushedFcn', @(btn,event) enhanceImage());

    btnDownloadImage = uibutton(fig, 'push', 'Text', 'Unduh Gambar', ...
        'Position', [100 80 100 30], 'Enable', 'off', ...
        'ButtonPushedFcn', @(btn,event) downloadImage());

    btnDownloadVideo = uibutton(fig, 'push', 'Text', 'Unduh Video', ...
        'Position', [220 80 100 30], 'Enable', 'off', ...
        'ButtonPushedFcn', @(btn,event) downloadVideo());

    lblProgress = uilabel(fig, 'Text', '', 'Position', [460 80 180 30]);

    img = [];
    videoReader = [];
    videoFrames = {};
    enhancedVideoFrames = {};
    frameRate = 30;

    function loadImage()
    % Reset state dari UI dan variabel
    img = [];  % Reset gambar
    videoFrames = {};  % Kosongkan frame video sebelumnya
    enhancedVideoFrames = {};  % Kosongkan frames video yang sudah di-enhance
    
    % Reset status tombol
    btnDownloadImage.Enable = 'off';
    btnDownloadVideo.Enable = 'off';
    btnEnhance.Enable = 'off';
    lblProgress.Text = '';  % Hapus teks progress

    [file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files'});
    if isequal(file, 0), return; end
    
    try
        % Cek apakah file gambar valid
        img = im2double(imread(fullfile(path, file)));
        if isempty(img)
            uialert(fig, 'Gambar tidak valid.', 'Error');
            return;
        end
        imshow(img, 'Parent', ax1);
        cla(ax2);
        btnEnhance.Enable = 'on';  % Enable tombol Enhance
    catch
        uialert(fig, 'Gagal memuat gambar. Pastikan file gambar sesuai format.', 'Error');
    end
end


    function loadVideo()
    % Reset state dari UI dan variabel
    img = [];  % Kosongkan gambar sebelumnya
    videoFrames = {};  % Kosongkan frame video sebelumnya
    enhancedVideoFrames = {};  % Kosongkan frames video yang sudah di-enhance
    
    % Reset status tombol
    btnDownloadImage.Enable = 'off';
    btnDownloadVideo.Enable = 'off';
    btnEnhance.Enable = 'off';
    lblProgress.Text = '';  % Hapus teks progress

    [file, path] = uigetfile({'*.mp4;*.avi;*.mov', 'Video Files'});
    if isequal(file, 0), return; end
    
    try
        % Cek apakah file video valid
        videoReader = VideoReader(fullfile(path, file));
        videoFrames = {};
        while hasFrame(videoReader)
            videoFrames{end+1} = readFrame(videoReader);
        end
        imshow(videoFrames{1}, 'Parent', ax1);
        cla(ax2);
        btnEnhance.Enable = 'on';  % Enable tombol Enhance
    catch
        uialert(fig, 'Gagal memuat video. Pastikan file video sesuai format.', 'Error');
    end
end


    function enhanceImage()
    if isempty(img) && isempty(videoFrames)
        uialert(fig, 'Silakan pilih gambar atau video terlebih dahulu.', 'Peringatan');
        return;
    end

    % Proses gambar
    if ~isempty(img)
        result = processFrame(img);
        imshow(result, 'Parent', ax2);
        btnDownloadImage.Enable = 'on';
        btnDownloadVideo.Enable = 'off';
    end

    % Proses video
    if ~isempty(videoFrames)
        lblProgress.Text = 'Memproses video...';
        drawnow;
        enhancedVideoFrames = {};
        
        try
            for k = 1:length(videoFrames)
                frame = im2double(videoFrames{k});
                result = processFrame(frame);
                enhancedVideoFrames{end+1} = result;

                % Preview setiap 10 frame atau frame terakhir
                if mod(k,10)==0 || k==length(videoFrames)
                    imshow(result, 'Parent', ax2);
                end
                
                % Update progress
                lblProgress.Text = sprintf('Frame: %d / %d', k, length(videoFrames));
                drawnow;
            end
            
            % Selesai proses video, update tombol dan label progress
            lblProgress.Text = 'Selesai memproses video.';
            btnDownloadVideo.Enable = 'on';
            btnDownloadImage.Enable = 'off';
        catch
            uialert(fig, 'Gagal memproses video.', 'Error');
            lblProgress.Text = '';
        end
    end
end

    function out = processFrame(in)
        in = im2double(in);
        gamma_corrected = imadjust(in, [], [], 0.6);

        contrast_enhanced = zeros(size(gamma_corrected));
        for c = 1:3
            contrast_enhanced(:,:,c) = adapthisteq(gamma_corrected(:,:,c), 'ClipLimit', 0.01);
        end

        denoised = imbilatfilt(contrast_enhanced);
        out = imsharpen(denoised, 'Radius', 1, 'Amount', 0.7);
    end

    function downloadImage()
    if isempty(img)
        uialert(fig, 'Tidak ada gambar yang tersedia untuk diunduh.', 'Peringatan', 'Icon', 'warning');
        return;
    end
    [file, path] = uiputfile({'*.png', 'PNG'; '*.jpg', 'JPEG'}, 'Simpan Gambar');
    if isequal(file, 0), return; end
    try
        f = getframe(ax2);
        imwrite(f.cdata, fullfile(path, file));
        % Notifikasi berhasil dengan ikon check (berhasil)
        uialert(fig, 'Gambar berhasil disimpan!', 'Info', 'Icon', 'success');
    catch
        uialert(fig, 'Gagal menyimpan gambar.', 'Error', 'Icon', 'error');
    end
end

    function downloadVideo()
    if isempty(enhancedVideoFrames)
        uialert(fig, 'Tidak ada video yang tersedia untuk diunduh.', 'Peringatan', 'Icon', 'warning');
        return;
    end
    [file, path] = uiputfile('*.mp4', 'Simpan Video');
    if isequal(file, 0), return; end
    try
        videoWriter = VideoWriter(fullfile(path, file), 'MPEG-4');
        videoWriter.FrameRate = frameRate;
        open(videoWriter);
        for k = 1:length(enhancedVideoFrames)
            writeVideo(videoWriter, enhancedVideoFrames{k});
        end
        close(videoWriter);
        % Notifikasi berhasil dengan ikon check (berhasil)
        uialert(fig, 'Video berhasil disimpan!', 'Info', 'Icon', 'success');
    catch
        uialert(fig, 'Gagal menyimpan video.', 'Error', 'Icon', 'error');
    end
end
end
