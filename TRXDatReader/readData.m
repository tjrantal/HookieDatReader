    %Function to read all of the data packets
    function data = readData(dataToMem)
        global pointer;
        data = [];
        packetNo = 0;
        wb = waitbar(0,'reading packets');
        while pointer < length(dataToMem)
            packet = readPacket(dataToMem);
            pointer = pointer+512;  %Packet size = 512 bytes + 2 bytes for aa -code of the packet
            packetNo = packetNo+1;
            data = [data, packet];%.packet(packetNo) =packet;
%             keyboard
            waitbar(pointer/length(dataToMem),wb);
        end
        close(wb);
    end