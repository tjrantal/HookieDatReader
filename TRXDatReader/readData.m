    %Function to read all of the data packets
    function data = readData(dataToMem)
        global pointer;
        data = struct();
        data.values = [];
        data.timeStamps = [];
        packetNo = 0;
%         wb = waitbar(0,'reading packets');
        while pointer < length(dataToMem)
            packet = readPacket(dataToMem);
            pointer = pointer+512;  %Packet size = 512 bytes + 2 bytes for aa -code of the packet
            packetNo = packetNo+1;
            data.values = [data.values, packet.data];%.packet(packetNo) =packet;
            data.timeStamps = [data.timeStamps, packet.timeStamp];
			if pointer/length(dataToMem) < 1 && mod(packetNo,20) == 0
%             	waitbar(pointer/length(dataToMem),wb);
            end
        end
%         close(wb);
    end
