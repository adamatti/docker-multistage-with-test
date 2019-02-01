import groovy.util.logging.Slf4j

@Slf4j
class Main {
    static void main(String [] args){
        while(true){
            log.info("Running")
            Thread.sleep(1000)
        }
    }
}
