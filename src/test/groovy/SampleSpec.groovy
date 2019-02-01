import spock.lang.Specification

class SampleSpec extends Specification{
    def "sample test"(){
        expect:
            1 == 2 // fail by purpose
    }
}
