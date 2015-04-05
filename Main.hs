
import Battery
import Network
import Time
import CPU
import Memory
import Power
import Disk
import Control.Concurrent (threadDelay)
import Text.Printf (printf)

mainLoop :: BatteryHandle -> NetworkHandle -> CPUHandle -> MemoryHandle -> PowerHandle -> DiskHandle -> IO()
mainLoop bh nh ch mh ph dh = do
  (p, bc) <- getCurrentLevel bh
  (s, bn) <- getTimeLeft bc
  (pow, ph) <- getPowerNow ph
  let h = s `div` 3600
  let m = (s - h * 3600) `div` 60
  (r, w, nn) <- getReadWrite nh
  ts <- getTime "%H:%M %d.%m.%y"
  (cp, cn) <- getCPUPercent ch
  (ct, cn) <- getCPUTemp cn
  (cf, cn) <- getCPUMaxScalingFreq cn
  (mp, mn) <- getMemoryAvailable mh
  (dr, dw, dn) <- getDiskReadWrite dh
  putStrLn (printf "%.1fW %3d%% %02d:%02d | MemFree: %dM | R/W: %dkbit/%dkbit | %s" pow p h m mp (r`div`1000`div`125) (w`div`1000`div`125) ts)
  putStrLn ((show cp) ++ (show ct))
  printf "%.1f\n" cf
  printf "%d %d\n" dr dw
  threadDelay 1000000
  mainLoop bn nn cn mn ph dn

main :: IO()
main = do
  bh <- getBatteryHandle
  nh <- getNetworkHandle "wlan0"
  ch <- getCPUHandle
  mh <- getMemoryHandle
  ph <- getPowerHandle
  dh <- getDiskHandle "sda"
  mainLoop bh nh ch mh ph dh
