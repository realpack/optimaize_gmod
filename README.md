 - В `./srcds_run` - находим такие строки `ulimit -c 2000` и заменяем на `ulimit -c unlimited`. Это позволит нам импользовать больше ресурсов и убрать некоторые ошибки сегментации.

 - Можно поигратся с этими значениями в `server.cfg`:
  ```cfg
    mem_max_heapsize "2048"
    threadpool_affinity "4" // 8 for octa-core, 6 for hexa-core, 4 for quad-core, 2 for double-core
  ```
